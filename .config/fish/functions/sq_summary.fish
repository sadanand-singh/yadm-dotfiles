function sq_summary -d 'slurm status at washU Cluster'
    ssh wg-sadanand@10.27.119.121 python3 /storage/group/whiterabbit/slurm-summary/sq_summary.py
end
