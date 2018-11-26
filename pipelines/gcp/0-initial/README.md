# Initial Pipelines

This set of initial pipelines create and app and several pipelines with various configurations that will be used by later pipelines. 

Thus you will perform the following:
1. Create and App
2. Add two simple pipelines
3. execute the pipelines via spinnaker user experience and/or using the pre-installed [Spin cli](https://github.com/spinnaker/spin)  

## Setup Procedure

*Note: these directions document procedure using the spin cli with a vanilla capstan deployment (IE no DNS/TLS/Oauth2)*

### Create app

The app you will create is called *helloagain*. This is your typical hello world app that we will associate with several pipelines going forward.

1. Access the tools instance 
   1. One shell with ssh tunnel options
      1. perform `hal deploy connect`
   1. Another (second) shell that you will be your command window
1. In the second shell navigate to where the *GCP* pipelines are located
1. Run the following command with the `Spin` cli
   1. `spin application save --application-name helloagain --owner-email CapstanonAWS@kenzan.com --cloud-providers kubernetes`
1. Verify successfull app creation with the `Spin` CLI.
   1. `spin application list`

### Push pipelines

Using the same terminal that you used to create the app perform the following commands to create two very simple deploy pipelines


1. spin pipeline save --file=uat_deploy.json
1. spin pipeline save --file=prod_seed.json


To verify they are present execute:
`spin pipeline list --application helloagain`

### Create Load Balancers

In the same folder where you just pushed to pipelines to spinnaker execute the following two commands

1. `kubectl apply -f prod-loadbalancer.yaml` 
1. `kubectl apply -f uat-loadbalancer.yaml`
1. `kubectl apply -f dev-loadbalancer.yaml`


## Run pipelines

With the app create and two pipelines present, access the spinnaker UI and execute both pipelines. Then try to access both apps. 

# ... Next Steps

In this "execise" you used the spin cli to configure a spinnaker instance, kubectl to create loadbalancers (we will explore another method later) and executed both pipelines. Next, we will do a few more fancy pipelines and demonstrate other integrations with GCP. 

