currentBuild.displayName = "Final Project # "+currentBuild.number

def getDockerTag(){
        def tag = sh script: 'git rev-parse HEAD', returnStdout: true
        return tag
		}

pipeline{
	agent any
        environment{
	    Docker_tag = getDockerTag()
        }
        stages{
              stage('Quality Gate Status Check'){
                  steps{
                      script{
			      withSonarQubeEnv('sonarserver') { 
			      sh "mvn clean sonar:sonar"
                       	     	}
			      timeout(time: 1, unit: 'HOURS') {
			      def qg = waitForQualityGate()
				      if (qg.status != 'OK') {
					   error "Pipeline aborted due to quality gate failure: ${qg.status}"
				      }
                    		}
					// mvn clean install tells Maven to do the clean phase in each module before running the install phase for each module.
		    	    sh "mvn clean install"
					sh "echo Done"
		  
                 	}
               	 }  
              }
              stage('Docker Build'){
				steps{
					script{
						sh "echo '' | sudo -S sudo su" 
						sh 'sudo docker build . -t shadidevsecops/web-app:$Docker_tag'
						withCredentials([string(credentialsId: 'docker_password', variable: 'docker_password')]) {
							sh 'sudo docker login -u shadidevsecops -p $docker_password'
							sh 'sudo docker push shadidevsecops/web-app:$Docker_tag'
							}
						}
					}
                }
			stage('Ansible Playbook'){
				steps{
					script{
						sh '''final_tag=$(echo $Docker_tag | tr -d ' ')
						echo ${final_tag}test
						sed -i "s/docker_tag/$final_tag/g"  deployment.yaml
						'''
						//ansiblePlaybook become: true, installation: 'ansible', inventory: 'hosts', playbook: 'ansible.yaml'
						ansiblePlaybook become: true, installation: 'ansible', inventory: 'hosts', playbook: 'ansible.yaml'
					}
				}
			}
		
        }	       	     	         
}
