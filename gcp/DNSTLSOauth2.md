# TLS all the things

This describes how to make your spinnaker accessible without and SSH tunnel. Luckily, this configuration is an option that you enable with minimal configuration on your part.

In this readme you will learn:
1. How to configure Oauth2 
2. How to configure TLS terminated spinnaker
3. What DNS steps you can have automated or manually configured

**Why?** Because we are all adults and we know that Token authentication, proper domain names, and TLS endpoints are the right things todo.


*These steps assume a GSUITE account and optionally (described later) Cloud DNS in the same google project*

## TL;DR

If you are using Google Cloud DNS in your project and GSuite you need to:
1. Generate (or obtain with letencrypt) private key and certificate
2. Create a Managed Zone with a valid domain for Cloud DNS
3. Create Oauth credentials (client ID/secret  )
4. capture all those values
5. update terraform
6. `terraform apply`


## Let's Beging
### DNS configuration with Google Cloud DNS


#### Oh, but I am not using Google Cloud DNS

Have no fear, you will be presented with an IP address to create the appropiate A records

#### Oh, but I do not have a DNS name

You don't have $12? 

### Configuring TLS


You have decided to go with CA signed certificates or Let's Encrypt. Because you are an adult and you know Self-signed is for chumps. 


### Configuring OAUTH2


## Activating 
