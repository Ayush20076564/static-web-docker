# docker/Dockerfile
FROM nginx:latest

# Remove default nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy all files from the current folder (where Dockerfile + HTML are)
COPY . /usr/share/nginx/html

# Expose port 80 for HTTP traffic
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
