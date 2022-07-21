# GIT ##################################
## Config
``` bash
git config --global user.name "Crislei Terassi Sorrilha"
git config --global user.email "crts.ms@gmail.com"
git config --global core.autocrlf true
```
## Removes and cleanup
``` bash
# Removes and cleanup staged and working directory changes
git reset --hard

# Remove  untracked
git clean -f -d

# As above, but removes ignored file config
git clean -f -x -d

# As above, but cleans untracked and ignored files through the entire repo
# Without :/ the operation affects only the current directory
git clean -fxd :/

# To see what will be deleted before-hand, withou actually deleting it
git clean -nfd

# To prune the upstream and to see it branch with remote status gone
git fetch -p
git branch -vv
```

## To solve conflicts when the branch is blocked to direct commit
``` bash
git checkout destinationBranch
git checkout -b resolve-conflicts-branch
git pull origin sourceBranch

# Resolve merge conflicts and commit and then
git push -u origin resolve-conflicts-branch

# Now create the pull request and done
```

# Docker
## Config
``` bash
docker login yourdockerprivaterepo.com
UserName: your_doker_user
Password: your_docker_password
```

## Debug
``` bash
# Purging all unsed or dangling images, containers, volumes and networks
docker system prune -a

#Override the entrypoint to debug a image
docker run --entrypoint "bin/sh" docker.com/image:latest -c "while true; do sleep 2; date; done"

#Copy app folder to local machine
docker cp {iIMAGE_ID}:/app/ .
```

## Portainer container admin
```bash
docker pull portainer/portainer
docker run -d -p 9000:9000 --name portainer --restart always \
 -v /var/run/docker.sock:/var/run/docker.sock \
 -v C:\docker\portainer\data:/data portainer/portainer
```

# OpenShift
## Config
```bash
oc login https://cluster_url.com:8443
```

## Debug and run containers
```bash
# Fire and stop cron-jobs 
oc get cronjobs
oc create job --from=cronjob/{CRON_JOB_NAME} {JOB_EXECUTION_NAME}
oc delete job {JOB_EXECUTION_NAME}

# Getting running pods
oc get pods --selector='job-name={JOB_EXECUTION_NAME}' -o custom-columns=:.metadata.name
oc get pods | grep {POD_PARTIAL_NAME}*

# Getting pods and keep connected
oc get pods --selector='app={APP_NAME}' -w

# Connect to stdout of a running pod
oc logs -f {POD_NAME}

# Delete pod
oc delete pods {POD_NAME} --grace-period=0 --force

# Port forward
oc port-forward services/{SERVICE_NAME} 8080:80
```

# Hashcorp Vault
```bash
vault login -address="https://vault_url.com"
vault kv get =address "https://vault_url.com" --format=json your/secret/path
```

# Certificates tools
```bash
# Get a public certificate of a given URL in PEM format
openssl s_client \
 -showcerts \
 -connect google.com:443 \
 -servername google.com.com </dev/null 2>/dev/null|openssl x509 \
 -outform PEM > certificate.pem

# Verify the ssl handshake
openssl s_client -connect google.com:443 -CApath /etc/ssl/certs

# Get a public certificated and install on a docker container
RUN openssl s_client -showcerts -verify 5 -connect google.com:443 < /dev/null | awk '/BEGIN/,/END/{ if(/BEGIN/){a++}; out="cert"a".pem"; print >out}'
COPY cert2.pem /usr/local/share/ca-certificates/cert2.pem
RUN chmod 644 /usr/local/share/ca-certificates/cert2.pem && update-ca-certificates
```