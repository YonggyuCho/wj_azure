# 기본 Tomcat 8.5 기반 이미지 사용
FROM tomcat:8.5


# Tomcat 설정 파일 복사
COPY ./conf/server.xml /usr/local/tomcat/conf/
COPY ./conf/context.xml /usr/local/tomcat/conf/
COPY ./lib/mysql-connector-j-8.0.33.jar /usr/local/tomcat/lib/

# Tomcat 웹 애플리케이션 배포 폴더 복사
COPY ./webapps/ /usr/local/tomcat/webapps/

# 환경변수 설정 파일 추가
COPY ./bin/setenv.sh /usr/local/tomcat/bin/
RUN chmod +x /usr/local/tomcat/bin/setenv.sh

# 실행 권한 추가 (Tomcat 실행 파일)
RUN chmod +x /usr/local/tomcat/bin/*.sh

# Tomcat 포트 설정
EXPOSE 8080

# Tomcat 실행
CMD ["catalina.sh", "run"]
