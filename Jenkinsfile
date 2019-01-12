import hudson.EnvVars

//  This Jenkingfile will talk to Nexus grap existing version of application and assing as env.existVersion
//  Then will get git last release
//  If version does not matches Job will build the image and push to nexus

node {
  stage('poll') {
    // Poll last update of the default branch

    // Prod branch (master)
    git credentialsId: 'git_account', url: 'https://github.com/fscoding/rabbitmq.git'

    // Testing branch
    // git branch: 'jenkins', credentialsId: 'git_account', url: 'https://github.com/fscoding/rabbitmq.git'
  }

  stage('Build docker image') {

    // Build the image
      app = docker.build("fscoding-rabbitmq")
  }

  stage('Push image') {

     // Push image to the Nexus with new release
      docker.withRegistry('http://nexus.fscoding.com:8082', 'docker-private-credentials') {
          app.push("test")
      }
  }
}
