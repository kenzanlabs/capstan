# TLS all-the-things

This describes how to make your spinnaker accessible without an SSH tunnel. Luckily, this configuration is an option that you enable with minimal configuration on your part. However, this should be considered an advanced configuration. 

In this readme you will learn:
1. How to configure Oauth2 
2. How to configure TLS terminated at the load balancer for spinnaker
3. What DNS steps you can have automated or manually configured

**Why?** Because we are all adults and we know that token authentication, proper domain names, and TLS endpoints are the right things todo.

In this document:
- $DOMAIN is used to represent the domainname like `example.com`
- $IP is used to represent an IP address

## TL;DR

If you are using Google Cloud DNS in your project and GSuite you need to:
1. Generate (or obtain with letencrypt) private key and certificate
2. Create a Managed Zone with a valid domain for Cloud DNS
3. Create Oauth credentials (client ID/secret  )
4. capture all those values
5. update terraform
6. `terraform apply`


## Let's Begin
### DNS configuration with Google Cloud DNS

The automated approach assumes you are using [Google Cloud DNS](https://cloud.google.com/dns/) in the same project.

1. Create a [Managed Zone](https://cloud.google.com/dns/quickstart)
2. Record the zone name
3. Update the following terraform attributes in `variables.tf`:
   1. `gcp_dns_zonename` with  the zone name
   2. `ux_fqdn` with the full domain name for spinnaker user experience like spinnaker.$DOMAIN, do not add protocal (AKA http or https)
   3. `api_fqdn` with the full domain name for Spinnaker API  like spinnaker-api.$DOMAIN, do not add protocal (AKA http or https)


DONE, the automation will update the DNS name.


#### Oh, but I am not using Google Cloud DNS

Have no fear, as capstan builds the environment with DNS enabled it will output the $IP address of the L7 LoadBalancer that performs host path management to the right Spinnaker subsystem. 

You still need to update terraform attributes in `variables.tf`
1. `ux_fqdn` with the full domain name for spinnaker user experience like spinnaker.$DOMAIN, do not add protocal (AKA http or https)
2. `api_fqdn` with the full domain name for Spinnaker API  like spinnaker-api.$DOMAIN, do not add protocal (AKA http or https)

On your DNS provider you will create two `A` records with the $IP emitted as part of the CAPSTAN build process. 

```
google_compute_instance.halyardtunnel (remote-exec): ==========================================
google_compute_instance.halyardtunnel (remote-exec):  - IP is  35.186.225.196 for spinnaker.example.com and spinnaker-api.example.com -
google_compute_instance.halyardtunnel (remote-exec): ==========================================
```

Yes, the same $IP for both the UX and API since we are using an L7 load balancer.

Leave `gcp_dns_zonename` as is. 

#### Oh, but I do not have a DNS name

You don't have $12?

### Configuring TLS
You have decided to go with CA signed certificates or Let's Encrypt. Because you are an adult and you know Self-signed is for chumps. *This version currently uses a wildcard certificate to cover both DNS names required and was tested with Lets's Encrypt using certbot [here](https://gist.github.com/nparks-owasp/517503264e04925ce1a1f3685c61805d).*

Your procedure is as follows:
1. Obtain a private key that was used to create your certificate
2. obtain the certificate file....make sure the CN (common name) is `*.$DOMAIN` like `*.example.com`
3. place the private key file in the `terraform` folder and name it `private.pem`
4. place the certificate file in the `terraform` folder and name it `certificate.crt`

DONE

### Configuring OAUTH2

Finally, we need to perform OAUTH2 configuration. For a successfull configuration we need the following four pieces of information:

1. The Client ID
2. The Client Secret
3. ~~Which provider...string value from [google|github|azure]~~ only google is supported by capstan at present
4. Domain Restiction `mycompany.com`


- Capstan was tested with GSUITE/GCP. To set-up Oauth2 in your GCP project follow the support [guide](https://support.google.com/cloud/answer/6158849).
- When setting up the credentials make sure you set the authorized redirect URL to `https://$api_fqdn/login` like https://spinnaker-api.example.com/login and the `http` version. So you should have two redirect url(S), one that is `http` and the other `https`

You will need to update the terraform attributes in `variables.tf`
- `oauth2_clientid` with the clientId
- `oauth2_secret` with the client secret
- `gsuite` with the gsuite domain of who is allowed to login.
 

## Activating 

If you have updated all the variables terraform attributes in `variables.tf` up to this point you are almost ready to activate the DNS/TLS/Oauth2 capability. 

To active perform the following

1. rename `tls.tf.noop` in the terraform folder for gcp to `tls.tf`
1. Uncomment the following lines in `instance.tf`
   1. `#"google_compute_ssl_certificate.genericwildcard",`
   1. `#"/home/${var.ssh_user}/enableOauth2.sh ${var.gcp_project_id} ${var.ux_fqdn} ${var.api_fqdn} ${var.oauth2_clientid} ${var.oauth2_secret} ${var.gsuite}",`
   1. `#"/home/${var.ssh_user}/enablednstls.sh ${var.gcp_project_id} ${var.ux_fqdn} ${var.api_fqdn} ${var.gcp_dns_zonename}",`


# Fire at will

 Whoa that was intense! Time to return to the main readme to perform `terraform plan`

 **Since this version is using GCP's [L7 loadbalancer](https://github.com/kubernetes/ingress-gce/) for TLS termination, there is an async operation that delays readiness. This is noted in the output near the end of a succeesful build**


# Clean up when done

When you are done with this environment created by CAPSTAN you have to perform two manual clean-up steps before using `terraform destroy`. You have to manually remove the ingress resource that created the loadbalancer serving https://$UI_FQDN for spinnaker. You will also need to manual purge DNS entries

1. Access the kubernetes section of the Google Cloud Console
1. Locate the `Services` sub section and locate the `spinnaker-app-ingress`
1. Delete that entry
1. Delete the DNS entries from your DNS provider (Google Cloud DNS or otherwise)

You can now `terraform destroy`
