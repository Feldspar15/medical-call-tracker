@echo off
echo Installing Medical Call Tracker Dependencies...
echo.

echo Step 1: Installing Node.js dependencies...
npm install

echo.
echo Step 2: Creating environment file...
if not exist .env.local (
    copy .env.example .env.local
    echo Please edit .env.local with your Supabase credentials before running the app.
    echo.
)

echo Step 3: Installation complete!
echo.
echo To run the development server:
echo npm run dev
echo.
echo To build for production:
echo npm run build
echo.
echo Don't forget to:
echo 1. Set up your Supabase database using database_setup.sql
echo 2. Update .env.local with your Supabase credentials
echo 3. Run 'npm run dev' to start the development server
echo.
pause