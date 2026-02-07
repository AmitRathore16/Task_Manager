Task Manager - This project is a cross-platform Task Management Application developed using Flutter and Supabase. The application allows users to sign up, sign in, and manage their personal tasks.

Features:
• Authentication (Sign up, Sign in, Sign out) using Supabase.
• Add, edit, and delete tasks.
• Mark tasks as completed or pending.
• Dark mode toggle button.

Software Requirements:
Before running the project, the following software must be installed:
• Flutter SDK (3.8.1 or higher).
• Dart SDK (comes with Flutter).
• Android Studio or VS Code.
• Git.
• Supabase account.

Setup Instructions:
Step 1: Clone the repository.
Step 2: Install dependencies using
Step 3: Configure environment variables by creating a .env file.
Step 4: Add the following credentials in the .env file:
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key

Supabase Setup Instructions:
Step 1: Create a new Supabase project.
Step 2: Create a table named tasks with the required columns (id, user_id, title, is_completed, created_at).
Step 3: Enable Row Level Security.
Step 4: Add policies to allow users to access only their own tasks.

Hot Reload vs Hot restart:
Hot restart runs the entire application from beginning by running the main function again. when we do hot restart, entire state of app is reset and then built again.
Hot reload only rebuilds the widget tree using updated code, the app state is preserved. Hot reload is faster as compared to Hot restart because in hot reload, the app is not getting built from starting.