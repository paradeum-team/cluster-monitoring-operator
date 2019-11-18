{
  prometheusRules+:: {
    groups+: [
      {
        name: 'kubernetes.rules',
        rules: [
          {
            expr: 'sum(container_memory_usage_bytes{container_name!="POD",pod_name!=""}) BY (pod_name, namespace)',
            record: 'pod_name:container_memory_usage_bytes:sum',
          },
          {
            expr: 'sum(container_spec_cpu_shares{container_name!="POD",pod_name!=""}) BY (pod_name, namespace)',
            record: 'pod_name:container_spec_cpu_shares:sum',
          },
          {
            expr: 'sum(rate(container_cpu_usage_seconds_total{container_name!="POD",pod_name!=""}[5m])) BY (pod_name, namespace)',
            record: 'pod_name:container_cpu_usage:sum',
          },
          {
            expr: 'sum(container_fs_usage_bytes{container_name!="POD",pod_name!=""}) BY (pod_name, namespace)',
            record: 'pod_name:container_fs_usage_bytes:sum',
          },
          {
            expr: 'sum(container_memory_usage_bytes{container_name!=""}) BY (namespace)',
            record: 'namespace:container_memory_usage_bytes:sum',
          },
          {
            expr: 'sum(container_spec_cpu_shares{container_name!=""}) BY (namespace)',
            record: 'namespace:container_spec_cpu_shares:sum',
          },
          {
            expr: 'sum(rate(container_cpu_usage_seconds_total{container_name!="POD"}[5m])) BY (namespace)',
            record: 'namespace:container_cpu_usage:sum',
          },
          {
            expr: 'sum(container_memory_usage_bytes{container_name!="POD",pod_name!=""}) BY (cluster) / sum(machine_memory_bytes) BY (cluster)',
            record: 'cluster:memory_usage:ratio',
          },
          {
            expr: 'sum(container_spec_cpu_shares{container_name!="POD",pod_name!=""}) / 1000 / sum(machine_cpu_cores)',
            record: 'cluster:container_spec_cpu_shares:ratio',
          },
          {
            expr: 'sum(rate(container_cpu_usage_seconds_total{container_name!="POD",pod_name!=""}[5m])) / sum(machine_cpu_cores)',
            record: 'cluster:container_cpu_usage:ratio',
          },
          {
            expr: 'sum(rate(cluster_monitoring_operator_reconcile_errors_total[15m])) * 100 / sum(rate(cluster_monitoring_operator_reconcile_attempts_total[15m])) > 10',
            alert: 'ClusterMonitoringOperatorErrors',
            'for': '15m',
            annotations: {
              message: 'Cluster Monitoring Operator is experiencing {{ printf "%0.0f" $value }}% errors.',
            },
            labels: {
              severity: 'critical',
            },
          },
        ],
      },
      {
        name: 'openshift-build.rules',
        rules: [
          {
            expr: 'sum(openshift_build_total{job="kubernetes-apiservers",phase="Error"})/(sum(openshift_build_total{job="kubernetes-apiservers",phase=~"Failed|Complete|Error"}))',
            record: 'build_error_rate',
          },
        ],
      },
      {
        name: 'bfs-rnode.rules',
        rules: [
          {
            expr: 'count by (rnodeid) (rnode_link_fnode_credit{status!="dying"})',
            record: 'rnodeid:rnode_link_fnode_credit:no_dying_count'
          },
          {
            expr: 'count by (rnodeid,status)(rnode_link_fnode_credit{})',
            record: 'rnodeid_status:rnode_link_fnode_credit:status_count'
          },
          {
            expr: 'count by (rnodeid) (rnode_link_fnode_credit{})',
            record: 'rnodeid:rnode_link_fnode_credit:count'
          },
          {
            expr: 'sum by (rnodeid) (rnode_link_fnode_qoutam{})',
            record: 'rnodeid:rnode_link_fnode_qoutam:sum'
          },
          {
            expr: 'sum by (rnodeid) (rnode_link_fnode_usedm{})',
            record: 'rnodeid:rnode_link_fnode_usedm:sum'
          },
          {
            expr: 'count by (rnodeid) (rnode_link_fnode_usedm_rate{} >= 0.85)',      
            labels:
              { quantile: "0.85" },
            record: 'rnodeid:rnode_link_fnode_usedm_rate:percentile_greater_equal_count'
          },
          {
            expr: 'count by (rnodeid) (rnode_link_fnode_usedm_rate{} < 0.85)', 
            labels:
              { quantile: "0.85" },
            record: 'rnodeid:rnode_link_fnode_usedm_rate:percentile_less_count'
          },
          {
            expr: 'count by (rnodeid) (rnode_link_fnode_usedm_rate{} >= 0.70)',      
            labels:
              { quantile: "0.70" },
            record: 'rnodeid:rnode_link_fnode_usedm_rate:percentile_greater_equal_count'
          },
          {
            expr: 'count by (rnodeid) (rnode_link_fnode_usedm_rate{} < 0.70)',      
            labels:
              { quantile: "0.70" },
            record: 'rnodeid:rnode_link_fnode_usedm_rate:percentile_less_count'
          },
          {
            expr: 'count by (rnodeid) (rnode_link_fnode_usedm_rate{} >= 0.50)',      
            labels:
              { quantile: "0.50" },
            record: 'rnodeid:rnode_link_fnode_usedm_rate:percentile_greater_equal_count'
          },
          {
            expr: 'count by (rnodeid) (rnode_link_fnode_usedm_rate{} < 0.50)',      
            labels:
              { quantile: "0.50" },
            record: 'rnodeid:rnode_link_fnode_usedm_rate:percentile_less_count'
          },
          {
            expr: 'count by (rnodeid) (rnode_link_fnode_credit{}<0.90)',
            labels:
              { quantile: "0.90" },
            record: 'rnodeid:rnode_link_fnode_credit:percentile_less_count'
          },
          {
            expr: 'count by (rnodeid) (rnode_link_fnode_credit{}<0.60)',
            labels:
              { quantile: "0.60" },
            record: 'rnodeid:rnode_link_fnode_credit:percentile_less_count'
          },
          {
            expr: 'avg by (rnodeid) (rnode_dltest_dlaccuracy{})',
            record: 'rnodeid:rnode_dltest_dlaccuracy:avg'
          },
          {
            expr: 'avg by (rnodeid) (rnode_dltest_dlspeed{})',
            record: 'rnodeid:rnode_dltest_dlspeed:avg'
          },
          {
            expr: 'count by (rnodeid) (rnode_uptest_time{issuccess="true",uptype="upload",upfield="afs"})',
            record: 'rnodeid:rnode_uptest_afs_time:success_count'
          },
          {
            expr: 'count by (rnodeid) (rnode_uptest_time{uptype="upload",upfield="afs"})',
            record: 'rnodeid:rnode_uptest_afs_time:count'
          },
          {
            expr: 'avg by (rnodeid) (rnode_uptest_time{uptype="upload",upfield="afs"})',
            record: 'rnodeid:rnode_uptest_afs_time:avg'
          },
          {
            expr: 'count by (rnodeid) (rnode_uptest_time{issuccess="true",uptype="upload",upfield="arfs"})',
            record: 'rnodeid:rnode_uptest_arfs_time:success_count'
          },
          {
            expr: 'count by (rnodeid) (rnode_uptest_time{uptype="upload",upfield="arfs"})',
            record: 'rnodeid:rnode_uptest_arfs_time:count'
          },
          {
            expr: 'avg by (rnodeid) (rnode_uptest_time{uptype="upload",upfield="arfs"})',
            record: 'rnodeid:rnode_uptest_arfs_time:avg'
          },
          {
            expr: 'count by (rnodeid) (rnode_uptest_time{issuccess="true",uptype="upload",upfield="agfs"})',
            record: 'rnodeid:rnode_uptest_agfs_alias:success_count'
          },
          {
            expr: 'count by (rnodeid) (rnode_uptest_time{uptype="upload", upfield="agfs"})',
            record: 'rnodeid:rnode_uptest_agfs_alias:count'
          },
          {
            expr: 'sum by (rnodeid) (rnode_fstat_daliy_download_file_count{})',
            record: 'rnodeid:rnode_fstat_daliy_download_file_count:sum'
          },
          {
            expr: 'sum by (rnodeid) (rnode_fstat_daliy_downloading_file_count{})',
            record: 'rnodeid:rnode_fstat_daliy_downloading_file_count:sum'
          },
          {
            expr: 'sum by (rnodeid) (rnode_ftask_daliy_task_count_in_server_dir{})',
            record: 'rnodeid:rnode_ftask_daliy_task_count_in_server_dir:sum'
          },
          {
            expr: 'sum by (rnodeid) (rnode_ftask_daliy_send_download_task_count{})',
            record: 'rnodeid:rnode_ftask_daliy_send_download_task_count:sum'
          },
          {
            expr: 'sum by (rnodeid) (rnode_link_fnode_block{})',
            record: 'rnodeid:rnode_link_fnode_block:sum'
          },  
          {
            expr: 'sum by (rnodeid) (rnode_fafid_daily_total_afid_count{})',
            record: 'rnodeid:rnode_fafid_daily_total_afid_count:sum'
          },  
          {
            expr: 'sum by (rnodeid) (rnode_link_fnode_credit{})/rnodeid:rnode_link_fnode_credit:count',
            record: 'rnodeid:rnode_link_fnode_credit:rate'
          },
          {
            expr: 'rnodeid:rnode_dltest_dlaccuracy:avg < 100',
            alert: 'BfsRnodeDownloadTestError',
            'for': '5m',
            annotations: {
              message: 'rnode {{ $labels.rnodeid }} download test accuracy {{ $value }}% .',
            },
            labels: {
              severity: 'critical',
            }
          },
          {
            expr: 'sum by (rnodeid) (rnodeid:rnode_uptest_afs_time:success_count) / sum by (rnodeid) (rnodeid:rnode_uptest_afs_time:count) < 1',
            alert: 'BfsRnodeUploadTestAfsError',
            'for': '5m',
            annotations: {
              message: 'rnode {{ $labels.rnodeid }} upload test afs accuracy {{ printf "%0.0f" $value }}% .',
            },
            labels: {
              severity: 'critical',
            }
          },
          {
            expr: 'sum by (rnodeid) (rnodeid:rnode_uptest_arfs_time:success_count) / sum by (rnodeid) (rnodeid:rnode_uptest_arfs_time:count) < 1',
            alert: 'BfsRnodeUploadTestArfsError',
            'for': '5m',
            annotations: {
              message: 'rnode {{ $labels.rnodeid }} upload test arfs accuracy {{ printf "%0.0f" $value }}% .',
            },
            labels: {
              severity: 'critical',
            }
          },
          {
            expr: 'sum by (rnodeid) (rnodeid:rnode_uptest_agfs_time:success_count) / sum by (rnodeid) (rnodeid:rnode_uptest_agfs_time:count) < 1',
            alert: 'BfsRnodeUploadTestAgfsError',
            'for': '5m',
            annotations: {
              message: 'rnode {{ $labels.rnodeid }} upload test agfs accuracy {{ printf "%0.0f" $value }}% .',
            },
            labels: {
              severity: 'critical',
            }
          },
          {
            expr: 'rnodeid:rnode_fstat_daliy_download_file_count:sum > 20000',
            alert: 'BfsRnodeDownloadFileCountError',
            'for': '5m',
            annotations: {
              message: 'rnode {{ $labels.rnodeid }} download_file_count {{ $value }}% .',
            },
            labels: {
              severity: 'critical',
            }
          },
          {
            expr: '( rnodeid:rnode_link_fnode_credit:no_dying_count - (rnodeid:rnode_link_fnode_credit:no_dying_count offset 1m) ) / rnodeid:rnode_link_fnode_credit:no_dying_count < -0.3',
            alert: 'BfsRnodeFnodeWorkCountSharpDrop',
            'for': '1m',
            annotations: {
              message: 'rnode {{ $labels.rnodeid }} fnode work count drop rate {{ printf "%0.0f" $value }}% .',
            },
            labels: {
              severity: 'critical',
            }
          },
          {
            expr: 'rnodeid:rnode_link_fnode_credit:rate < 0.5',
            alert: 'BfsRnodeFnodeCreditRateError',
            'for': '5m',
            annotations: {
              message: 'rnode {{ $labels.rnodeid }} credit rate {{ $value }}% .',
            },
            labels: {
              severity: 'critical',
            }
          },
        ]
      }
    ],
  },
}

