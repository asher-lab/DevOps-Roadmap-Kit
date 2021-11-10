# Types of software testing
 
## Testing Type
1. Manual
2. Automatic
## Testing Methods
1. Static
2. Dynamic
## Testing Approaches
1. Black Box ( tester has no idea )
2. White Box ( tester has an idea )
3. Gray Box ( slight understanding of the app to be tested. )
## Testing Levels
1. Unit Testing
2. Integration Testing
3. System Testing
4. Acceptance Testing

# SonarQube - is a static testing analysis software.
 
 #### It can work on 25 different languages.
- Detect Bugs
- Code Smells ( Meaning best practice is not implemented, techical debt, there come future problems )
- Security Vulnerability, sonar cube can detect if for example a SQL statement is not closed, or if a password is written directly into the program
- Activates Rules Needed ( Quality Profiles ), rules that is specific to a specific project. Can be used on the rules of the team, or based on the nature of the project. This will make sure the future developer will going to follow the same path.
- Execution Path
- SonarQube can be directly integrated with: Github
- Discover Memory Leaks
- Good Visualizer
- Enforces a quality gate
- Digs into issues
- Plugins for IDEs

==================
# Step in Installing SonarQube manually
1. Follow the instructions here to install sonarqube:  https://techexpert.tips/sonarqube/sonarqube-docker-installation/  OR THIS ONE: https://huongdanjava.com/install-sonarqube-using-docker.html
```
docker pull sonarqube:7.9.5-community
```
2. `git clone https://github.com/gouthamchilakala/PetClinic.git `
3. Login into SonarQube, password is admin:admin
4. Install maven if ur project is in java.  
```
cd /opt
wget https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.6.2/apache-maven-3.6.2-bin.tar.gz
tar zxf apache-maven-3.6.2-bin.tar.gz
cd to maven and cd to bin
```
5. Install Java
```
sudo apt-get install openjdk-8-jdk
sudo apt-get install openjdk-8-jre
```
6. Check if installation is working:
```
./mvn version
```
7. Set maven available on the entire project location
```
export PATH=$PATH:/opt/apache-maven-3.6.2/bin
```
8. Navigate inside PetClinic repo
9. nano sonar-project.properties
```
# Required metadata
sonar.projectKey = java-sonar-runner-simple
sonar.projectName = Simple Java Proj analyzed using SonarQube
sonar.projectVersion = 1.0

# Comma-separated paths to directories with sources (required)
sonar.sources.src

# Language
sonar.language = java

# Encoding of the source files
sonar.sourceEncoding=UTF-8
```
10. Compile the project: `mvn compile`
11. Use the command:
```
mvn sonar:sonar \
  -Dsonar.projectKey=sample \
  -Dsonar.host.url=http://34.198.215.174:9000 \
  -Dsonar.login=f30c644398e8b4cceb92ea8dee58c0991fd312af
```
11. Check the project status in your dashboard.
