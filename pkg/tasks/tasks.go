// Copyright 2018 The Cluster Monitoring Operator Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package tasks

import (
	"github.com/openshift/cluster-monitoring-operator/pkg/client"
	"github.com/pkg/errors"
	"golang.org/x/sync/errgroup"
	"k8s.io/klog"
)

type TaskRunner struct {
	client *client.Client
	tasks  []*TaskSpec
}

func NewTaskRunner(client *client.Client, tasks []*TaskSpec) *TaskRunner {
	return &TaskRunner{
		client: client,
		tasks:  tasks,
	}
}

func (tl *TaskRunner) RunAll() error {
	var g errgroup.Group

	for i, ts := range tl.tasks {
		// shadow vars due to concurrency
		ts := ts
		i := i

		g.Go(func() error {
			klog.V(3).Infof("running task %d of %d: %v", i+1, len(tl.tasks), ts.Name)
			err := tl.ExecuteTask(ts)
			klog.V(3).Infof("ran task %d of %d: %v", i+1, len(tl.tasks), ts.Name)
			return errors.Wrapf(err, "running task %v failed", ts.Name)
		})
	}

	return g.Wait()
}

func (tl *TaskRunner) ExecuteTask(ts *TaskSpec) error {
	return ts.Task.Run()
}

func NewTaskSpec(name string, task Task) *TaskSpec {
	return &TaskSpec{
		Name: name,
		Task: task,
	}
}

type TaskSpec struct {
	Name string
	Task Task
}

type Task interface {
	Run() error
}
