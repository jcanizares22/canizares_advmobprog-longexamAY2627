# How to Push This Flutter Project to GitHub

Repository:

`https://github.com/jcanizares22/canizares_advmobprog-longexamAY2627`

## 1. Open the Project Folder

Open PowerShell and run:

```powershell
cd "C:\Users\guest-user\Desktop\canizares_labact4\Canizares_LabAct\canizares_labact4"
```

## 2. Check the Git Status

```powershell
git status
```

If the folder is not yet a Git repository, initialize it:

```powershell
git init
```

## 3. Check Sensitive Files

Before adding files, make sure `.gitignore` includes these entries:

```gitignore
.dart_tool/
build/
.pub/
android/.gradle/
android/key.properties
```

Do not push passwords, signing keys, API keys, or other secrets.

## 4. Add the GitHub Repository

```powershell
git remote add origin https://github.com/jcanizares22/canizares_advmobprog-longexamAY2627.git
```

If `origin already exists` appears, update it instead:

```powershell
git remote set-url origin https://github.com/jcanizares22/canizares_advmobprog-longexamAY2627.git
```

## 5. Add and Commit the Project

```powershell
git add .
git status
git commit -m "Complete Flutter long exam project"
```

Review the `git status` output before committing to ensure that unwanted files are not included.

## 6. Push the Project

```powershell
git branch -M main
git push -u origin main
```

GitHub may open a browser for authentication. Sign in with the correct GitHub account if prompted.

## If the Push Is Rejected

If the online repository already contains files, synchronize first:

```powershell
git pull --rebase origin main
git push -u origin main
```

If a merge conflict appears, resolve the marked files, then run:

```powershell
git add .
git rebase --continue
git push -u origin main
```

## Confirm the Upload

Refresh the GitHub repository page and check that the Flutter project files are visible.
