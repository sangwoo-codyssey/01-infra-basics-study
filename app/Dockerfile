FROM nginx:latest

# 직접 작성한 정적 페이지를 NGINX 기본 경로에 복사
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
