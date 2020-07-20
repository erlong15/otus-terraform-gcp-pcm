Deployment:
- Create your own file terraform.tfvars;
- Run the following commands:
```bash
terraform init
terraform apply
ansible-playbook ansible/main.yml
```

Docs:
- [Ansible - Inventory plugins list](https://docs.ansible.com/ansible/latest/plugins/inventory.html#plugin-list)
- [Ansible - GCE scenario guide](https://docs.ansible.com/ansible/latest/scenario_guides/guide_gce.html)
- [Ansible - GCP Compute plugin](https://docs.ansible.com/ansible/latest/plugins/inventory/gcp_compute.html)
- [Google SDK - login](https://cloud.google.com/sdk/gcloud/reference/auth/application-default/login)
- [Google - SAP HANA](https://cloud.google.com/solutions/sap/docs/sap-hana-ha-config-rhel)
- [Red Hat - RHEL over GCP](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/deploying_red_hat_enterprise_linux_8_on_public_cloud_platforms/configuring-rhel-ha-on-gcp_deploying-a-virtual-machine-on-aws)
- [Red Hat - SAP HANA cluster](https://access.redhat.com/articles/3004101)
- [DRBD with Absible](https://github.com/mrlesmithjr/ansible-drbd)
- [SAP over GCP](https://medium.com/@stotapally/high-availability-for-sap-applications-on-google-cloud-platform-64d66db5989e)
- [SAP over GCP on SUSE](https://medium.com/@stotapally/high-availability-for-sap-hana-scale-up-on-suse-on-gcp-4f37173be04b)
- [SUSE - HA cluster guide](https://documentation.suse.com/sles-sap/15-SP1/html/SLES4SAP-guide/cha-s4s-cluster.html)
- [SUSE - SAP with Terraform over GCP](https://github.com/SUSE/ha-sap-terraform-deployments/tree/master/gcp)
- [Recommendations for HA over GCP](https://medium.com/google-cloud/recommendations-for-high-availability-failover-on-google-compute-engine-f4ff409fcf10)

Useful commands
```bash
export GOOGLE_APPLICATION_CREDENTIALS="/test.json"
fence_gce --zone=europe-north1-a --project=otus-gcp-pcm -o list -vvv
/usr/sbin/fence_gce --zone=europe-north1-a --project=otus-gcp-pcm -o list -vvv
fence_gce --zone=europe-north1-a --project=otus-gcp-pcm --plug="pcm-stand-2"
pcs stonith fence pcm-stand-0
```
