def gv

pipeline {
    agent any
	parameters {
		choice(name: 'VERSION', choices:['1.1.0', '1.2.0', '1.3.0'], description: '')
		booleanParam(name: 'executeTests', defaultValue: true, description: '')
	}
    stages {
        stage("init") {
            steps {
				script {
					gv = load "script.groovy"
				}
            }
        }
      
	  
	    stage("test") {
			when {
				expression{
					params.executeTests
				}
			}
            steps {			
			script {			
					gv.testApp()					
				}              
            }
        }
    
	
        stage("build jar") {
            steps {
				script {			
					gv.buildApp()					
				}          
            }
        }
      
        stage("deploy") {
		
			input {
				message "Select the deployment environment for the system: "
				ok "Done!"
				parameters {
					choice(name: 'ONE', choices:['dev', 'staging', 'production'], description: '')
					choice(name: 'TWO', choices:['dev', 'staging', 'production'], description: '')
				}
			}
            steps {
			script {			
					gv.deployApp()			
					echo "Deployed to ${ONE}"
					echo "Deployed to ${TWO}"
				}      
        }
  




  }   
}
    
    
}
