# Collab Hub API  

**Collab Hub** is a streamlined project management API designed to help teams collaborate efficiently, inspired by tools like Trello and Asana.  

---

## Features  
- Manage multiple projects seamlessly.  
- Create, update, and delete tasks for better project organization.  
- Assign tasks to specific team members for accountability.  
- Track task statuses: **To Do**, **In Progress**, and **Completed**.  
- Connect to the **GitHub API** to fetch repositories of authenticated users.  

---

## Table of Contents  
1. [Requirements](#requirements)  
2. [Installation](#installation)  
3. [Configuration](#configuration)  
4. [Running the Application](#running-the-application)  
5. [Running Tests](#running-tests)  
6. [API Documentation](#api-documentation)  
7. [Architecture Decisions](#architecture-decisions)  
8. [Contributing](#contributing)  

---

## Requirements  
Ensure you have the following tools installed:
- **Docker** (required)  
- **Docker composer** (required)
- **Ngrok** (to expose your localhost and can use Github API functions)
- **Create a `.env` file at the root directory and add the necessary environment variables:**
```bash
APP_DATABASE_NAME=collab_hub
APP_DATABASE_USERNAME=postgres
APP_DATABASE_PASSWORD=postgres
APP_DATABASE_HOST=collab_hub_db
APP_DATABASE_PORT=5432
RAILS_ENV=production
GITHUB_CLIENT_ID=<ASK FOR IT>
GITHUB_CLIENT_SECRET=<ASK FOR IT>
GITHUB_REDIRECT_URI=<NGROK_URL>
GITHUB_URL=https://github.com
GITHUB_API_URL=https://api.github.com
SIDEKIQ_USERNAME=admin
SIDEKIQ_PASSWORD=123456789
REDIS_URL='redis://collab_hub_redis:6379/0'
```

---

## Installation  

Follow these steps to set up the project locally:  

1. **Clone the repository**:  
   ```bash
   git clone https://github.com/kevinlopez93/collab-hub.git
   cd collab-hub-api
   ```
---

## Running the Application  

Run the following command to build the image and run the container:   
```bash
docker compose up --build
```

By default, the server will run on `http://localhost:3000`.  

---

## Running Tests  

To ensure the application runs as expected, execute the following:  
1. **Run tests**:  
   Execute the full test suite with RSpec:  
   ```bash
   docker compose run app bash -c "RAILS_ENV=test bundle exec rspec"
   ```

---

## API Documentation  

Collab Hub's API is documented using **Postman**. Follow these steps to view the documentation:  
1.  **Postman**:  
   Import the provided Postman collection from the `docs` folder to interact with the API.  

---

## Architecture Decisions  

Collab Hub API was designed following best practices to ensure scalability, maintainability, and flexibility:  

1. **MVC Architecture**:  
   - Utilizes the Model-View-Controller pattern for clean separation of concerns.  
   - Models manage data logic, Controllers handle requests, and Views (when applicable) present responses.  

2. **RESTful API**:  
   - Endpoints adhere to REST conventions, providing predictable resource-based URLs for projects, tasks, and users.  

3. **External API Integration**:  
   - Integration with the **GitHub API** is handled via a service object to fetch user repositories securely.  

4. **Database**:  
   - Uses PostgreSQL for relational data management, ensuring strong consistency and support for structured data.  

5. **Service Objects**:  
   - Heavy business logic (e.g., interacting with GitHub API) is encapsulated in service objects to keep controllers clean and reusable.  

6. **Error Handling**:  
   - Consistent error responses are returned in JSON format with proper HTTP status codes.

7. **Background Jobs with Sidekiq and Redis**:  
   - For performance optimization and asynchronous processing, background jobs are used for time-consuming tasks, such as:  
     - **Processing GitHub repositories**: When users connect their GitHub account, the repositories are fetched via a scheduled task. This task is managed using the **Whenever gem** to schedule a cron job with **Crontab** (schduled every 1 minute), ensuring that repositories are regularly synced without blocking the main application flow.  
     - **Generating GitHub Access Tokens**: When GitHub sends the OAuth confirmation, the token generation process is handled in the background. This ensures that the user’s main request flow is not blocked while the token is generated and saved securely. 

---

## Contributing  

We welcome contributions! Please follow these steps:  
1. Fork the repository.  
2. Create a new branch: `git checkout -b feature/your-feature-name`.  
3. Make your changes and commit them: `git commit -m "Add feature description"`.  
4. Push your branch: `git push origin feature/your-feature-name`.  
5. Open a Pull Request.  

---

## Contact  

For any questions feel free to contact:  
**Kevin López**  Senior Ruby on Rails developer 

Email: i.kevinlop93@gmail.com  
GitHub: [@kevinlopez93](https://github.com/kevinlopez93)  
