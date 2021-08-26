pipeline {
    agent any
  
	parameters {
		
		choice(name: 'VERSION', choices:['1.1.0', '1.2.0', '1.3.0.'], description: '')
		booleanParam(name: 'executeTests', defaultValue: true, description: '')
	}
    stages {
        stage("init") {
            steps {
              echo "Initialzing the APP"
            }
        }
      
	  
	    stage("test") {
			
			when {
				expression{
					params.executeTests
				}
			}
		
            steps {
              echo "testing the application"
            }
        }
      
        stage("build jar") {
            steps {
                echo "building the app"
            }
        }
      
      
        stage("build image") {
            steps {
               echo "building the image"
            }
        }
      
      
        stage("deploy") {
            steps {
               echo "deploying the image on rep"
			   echo "deploying version: ${params.VERSION}"
        }
    }   
}
    
    
}
