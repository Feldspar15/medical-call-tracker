# Medical Call Tracker - Deployment Guide

## 🚀 Quick Start

### Prerequisites
1. Node.js (v18 or higher)
2. npm or yarn
3. Supabase account (free tier available)
4. GitHub account (for deployment)

### Local Development Setup

1. **Clone/Extract the Project**
   ```bash
   cd medcall-tracker
   ```

2. **Install Dependencies**
   ```bash
   npm install
   ```

3. **Set Up Environment Variables**
   - Copy `.env.example` to `.env.local`
   - Fill in your Supabase credentials (see Supabase Setup below)

4. **Run Development Server**
   ```bash
   npm run dev
   ```
   Open [http://localhost:3000](http://localhost:3000)

## 🗃️ Supabase Database Setup

### Step 1: Create Supabase Project
1. Go to [supabase.com](https://supabase.com)
2. Click "New Project"
3. Choose organization and name your project
4. Set a strong database password (save this!)
5. Select your region
6. Wait for project setup (2-3 minutes)

### Step 2: Run Database Schema
1. In Supabase dashboard, go to "SQL Editor"
2. Click "New Query"
3. Copy and paste the entire contents of `database_setup.sql`
4. Click "Run" to execute
5. Verify tables are created in "Table Editor"

### Step 3: Get API Keys
1. Go to "Settings" → "API"
2. Copy the following:
   - **Project URL** (starts with https://xxx.supabase.co)
   - **Anon/Public Key** (starts with eyJ...)
   - **Service Role Key** (starts with eyJ...)

### Step 4: Update Environment File
```env
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key_here
SUPABASE_SERVICE_KEY=your_service_role_key_here
NEXTAUTH_URL=http://localhost:3000
NEXTAUTH_SECRET=a_random_32_character_string_here
```

## 🌐 Deployment Options

### Option 1: Vercel (Recommended)

1. **GitHub Setup**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/yourusername/medcall-tracker.git
   git push -u origin main
   ```

2. **Deploy to Vercel**
   - Go to [vercel.com](https://vercel.com)
   - Sign in with GitHub
   - Click "New Project"
   - Import your repository
   - Add environment variables in settings
   - Deploy

3. **Environment Variables in Vercel**
   - Go to Project Settings → Environment Variables
   - Add all variables from your `.env.local`
   - Update `NEXTAUTH_URL` to your Vercel domain

### Option 2: Railway

1. **Connect GitHub**
   - Go to [railway.app](https://railway.app)
   - Connect your GitHub repository

2. **Add Environment Variables**
   - In Railway dashboard, go to Variables tab
   - Add all environment variables
   - Update `NEXTAUTH_URL` to your Railway domain

3. **Deploy**
   - Railway automatically deploys on git push

### Option 3: Netlify

1. **Build Command Setup**
   ```bash
   npm run build
   ```

2. **Deploy**
   - Connect GitHub repository
   - Set build command: `npm run build`
   - Set publish directory: `.next`
   - Add environment variables

## 🧪 Testing Checklist

### Manual Testing
- [ ] **Authentication**
  - [ ] User registration works
  - [ ] User login works
  - [ ] Session persistence
  - [ ] Logout functionality

- [ ] **Shift Management**
  - [ ] Start shift creates new shift
  - [ ] End shift completes shift
  - [ ] Only one active shift per user
  - [ ] Shift data displays correctly

- [ ] **Call Logging**
  - [ ] Incoming call creation
  - [ ] Callback creation
  - [ ] Call completion with duration
  - [ ] Form validation works
  - [ ] Auto-timestamps function

- [ ] **Data Display**
  - [ ] Dashboard shows recent shifts
  - [ ] Shift expansion shows call details
  - [ ] Call priority colors display
  - [ ] Duration calculations correct

- [ ] **Excel Export**
  - [ ] Export modal opens
  - [ ] Date range selection works
  - [ ] Export generates valid Excel file
  - [ ] Summary sheet includes statistics
  - [ ] Data sheet has correct formatting

- [ ] **Responsive Design**
  - [ ] Mobile layout works
  - [ ] Tablet layout works
  - [ ] Desktop layout works
  - [ ] All buttons accessible on mobile

### Security Testing
- [ ] Users can only see their own data
- [ ] Authentication required for all pages
- [ ] No SQL injection vulnerabilities
- [ ] Session timeout works
- [ ] Environment variables not exposed

## 🔧 Troubleshooting

### Common Issues

1. **"Cannot find module" errors**
   ```bash
   rm -rf node_modules package-lock.json
   npm install
   ```

2. **Database connection issues**
   - Verify Supabase URL and keys
   - Check if database schema was created
   - Verify Row Level Security policies

3. **Authentication not working**
   - Check `NEXTAUTH_URL` matches your domain
   - Verify `NEXTAUTH_SECRET` is set
   - Clear browser cookies and try again

4. **Build failures**
   - Check TypeScript errors: `npm run build`
   - Verify all environment variables are set
   - Check for missing dependencies

5. **Export not working**
   - Verify XLSX library is installed
   - Check browser console for JavaScript errors
   - Test with sample data first

### Performance Issues

1. **Slow page loads**
   - Check Supabase dashboard for query performance
   - Verify indexes are created (included in setup script)
   - Consider implementing pagination for large datasets

2. **Memory issues**
   - Limit export data size
   - Implement data pagination
   - Clear old browser cache

## 📊 Monitoring

### Production Monitoring
- Monitor Supabase dashboard for database usage
- Check Vercel/Railway analytics for performance
- Set up error tracking (optional: Sentry)

### Database Maintenance
- Regular backups (Supabase includes automatic backups)
- Monitor row counts and storage usage
- Consider data archiving for old records

## 🔄 Updates and Maintenance

### Regular Updates
1. Keep dependencies updated: `npm update`
2. Monitor security advisories
3. Test new features in development first
4. Backup database before major updates

### Feature Additions
- All new features should include proper typing
- Add to both mobile and desktop layouts
- Update database schema if needed
- Test export functionality with new data

## 📞 Support

### Getting Help
1. Check this deployment guide
2. Review troubleshooting section
3. Check GitHub issues
4. Supabase documentation: [docs.supabase.com](https://docs.supabase.com)
5. Next.js documentation: [nextjs.org/docs](https://nextjs.org/docs)

### Reporting Issues
When reporting issues, include:
- Error messages (full stack trace)
- Steps to reproduce
- Browser and version
- Environment (development/production)
- Relevant log files

---

**Successfully deployed? Great! Your Medical Call Tracker is now ready to help streamline call documentation for healthcare professionals.**