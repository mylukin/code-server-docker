
# code-server-docker

## Project Overview

This project packages code-server into a custom Docker image, allowing you to freely add software packages within Docker.

## Project Directory Structure

```
.
├── docker
│   ├── Dockerfile
│   └── entrypoint.sh
├── Makefile
├── nginx
│   └── code.example.com.conf
└── README.md
```

## Makefile Targets

- **run**: Runs the code-server container.
- **logs**: Displays logs for the code-server container.
- **stop**: Stops and removes the code-server container.
- **upgrade**: Pulls the latest image and stops the current container.
- **restart**: Stops and runs the code-server container.
- **build**: Builds the Docker image.
- **publish**: Pushes the Docker image to the repository.
- **release**: Builds and publishes the Docker image.

## Nginx Configuration

The following configuration is used to set up Nginx as a reverse proxy for the code-server:

```nginx
server {
    listen 80;
    server_name code.example.com;
    return 301 https://$server_name$request_uri;
}
server {
    listen 443 ssl;
    charset utf-8;

    root /dev/null;
    index index.html;

    server_name code.example.com;

    ssl_certificate /etc/nginx/ssl/example.com.cert;
    ssl_certificate_key /etc/nginx/ssl/example.com.key;

    location / {
        proxy_pass http://127.0.0.1:4040/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## How to Use

1. **Run the Container**:
   ```sh
   make run
   ```
   This command runs the code-server container with the specified configurations.

2. **View Logs**:
   ```sh
   make logs
   ```
   This command displays the logs for the code-server container.

3. **Stop the Container**:
   ```sh
   make stop
   ```
   This command stops and removes the code-server container.

4. **Upgrade the Container**:
   ```sh
   make upgrade
   ```
   This command pulls the latest image and stops the current container.

5. **Restart the Container**:
   ```sh
   make restart
   ```
   This command stops and runs the code-server container.

6. **Build the Docker Image**:
   ```sh
   make build
   ```
   This command builds the Docker image.

7. **Publish the Docker Image**:
   ```sh
   make publish
   ```
   This command pushes the Docker image to the repository.

8. **Release the Docker Image**:
   ```sh
   make release
   ```
   This command builds and publishes the Docker image.

## Customizing the Image

You can customize the Docker image by modifying the `Dockerfile` and `entrypoint.sh` in the `docker` directory. This allows you to add any additional software packages or configurations as needed.

## License

This project is licensed under the MIT License.
