## Git Commands and Explanations

Here's a comprehensive list of common Git commands, their brief explanations, and warnings about potentially dangerous commands.

### Git: Basic Commands

*   **`git init`**: Initializes a new Git repository in the current directory. This creates a `.git` subdirectory.
*   **`git clone <repository_url>`**: Creates a copy of an existing Git repository from a remote URL onto your local machine.
*   **`git add <file_name>` / `git add .`**: Stages changes for the next commit. 
    `git add <file_name>` stages a specific file, 
        while `git add .` stages all changes in the current directory.
*   **`git commit -m "Your commit message"`**: Records the staged changes to the repository with a descriptive message.
*   **`git status`**: Shows the status of your working directory and staging area, indicating which files are untracked, modified, or staged.
*   **`git diff`**: Shows changes between the working directory and the staging area, or between two commits.
*   **`git log`**: Displays the commit history, showing details like author, date, and commit message.
*   **`git push`**: Uploads local branch commits to the remote repository.
*   **`git pull`**: Fetches changes from the remote repository and merges them into your current local branch. (Equivalent to `git fetch` followed by `git merge`).
*   **`git fetch`**: Downloads objects and refs from another repository (e.g., a remote repository). It doesn't automatically merge or modify your current work.

### Git: Branching and Merging

*   **`git branch`**: Lists all local branches.
*   **`git branch <new_branch_name>`**: Creates a new branch.
*   **`git checkout <branch_name>`**: Switches to the specified branch.
*   **`git merge <branch_name>`**: Merges the specified branch into the current branch.
*   **`git branch -d <branch_name>`**: Deletes the specified local branch (only if it has been merged).
*   **`git branch -D <branch_name>`**: Force deletes the specified local branch, even if it hasn't been merged.

### Git: Advanced/Other
*   **`git rebase <base_branch>`**: Reapplies commits from your current branch onto another branch.
*   **`git switch <branch_name>`**: Switches to the specified branch. This command is a more modern and safer alternative to `git checkout` for switching branches.

---

## Composer Installation

### Windows Installation
For Windows environments, the easiest method is to download and run the [Composer-Setup.exe](https://getcomposer.org/Composer-Setup.exe) installer. This will automatically locate your PHP installation and add Composer to your system PATH.

---

## Creating a Laravel Project

Once Composer is installed and verified globally, you can use it to scaffold a fresh Laravel application. Navigate to your desired workspace directory in the terminal and run:

```bash
composer create-project laravel/laravel your-project-name
```

### Environment Configuration (.env)
Laravel relies on a `.env` file at the root of the project to store environment-specific configurations (like database credentials and API keys).

Key settings to configure upon setup:

*   **APP_URL**: Update this to match your local server address (e.g., `APP_URL=http://127.0.0.1:8000`) so the application generates correct absolute links.
*   **DB_CONNECTION**: By default, modern Laravel uses `sqlite`. When running database migrations (`php artisan migrate`), Laravel will automatically create the `database.sqlite` file, provided the SQLite extensions are enabled in your PHP configuration.

### Starting the Development Server
Navigate into your newly created project folder to start the application:

```bash
cd your-project-name
php artisan serve
```
*The application will be accessible in your browser at `http://127.0.0.1:8000`.*

**Custom Ports:** To run the server on a specific port, append the port flag with an equals sign: `php artisan serve --port=8019`.

### Frontend Asset Bundling (Vite)
Modern Laravel uses Vite to compile and serve frontend assets (CSS, JavaScript, React, etc.). To enable Hot Module Replacement (HMR) so the browser updates instantly when you save a file, open a second terminal window in your project folder and run:

```bash
npm install
npm run dev
```
*(Vite will start its own background server, usually on `http://localhost:5173/`, but you will still view your actual app through the `127.0.0.1:8000` URL).*
