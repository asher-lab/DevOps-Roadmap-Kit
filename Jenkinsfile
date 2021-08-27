pipeline {
    agent any
	tools { 
		maven 'Maven'
	}
	
    stages {
	

		stage("test") {
			steps {
				script {
					echo "Testing the code.."
					sh 'mvn test'
				}
			}
		}

		
		stage("build jar") {
			steps {
				script {
					echo "Bulding the application.."
					sh 'mvn package'
				}
			}
		}

		stage("build image") {
			steps {
				script {
					echo "Building docker image.."	
					withCredentials([usernamePassword(credentialsId: 'dockerhub-asherlab', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]
					
						sh 'docker build -t java-maven-app:jma-2.2 .'
						sh "echo $PASSWORD | docker login -u $USERNAME --password-stdin"
						sh 'docker tag java-maven-app:jma-2.2 asherlab/java-maven-app:jma-2.2'
						sh 'docker push asherlab/java-maven-app:jma-2.2'
				}
			}
		}

	}
	
		stage("deploy") {
			steps {
				script {
					echo "Deploying the package.."					
				}
			}
		}

	}  
	
	
	
	
	
	
	
	
}
