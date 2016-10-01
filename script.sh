#!/bin/sh

# Exemple: bash
REPO_NAME=""
# Exemple: psykoterro
USER_NAME=""
# Exemple: me@mydomain.com
USER_EMAIL=""
# Exemple: /path/to/id_rsa
SSH_KEY="";

PS3='Que souhaitez-vous faire ?'
OPTIONS=(

  "Creer Nouveau Site"
  "Creer Nouveau Repo GitHub"
  "[Git] Commit to remote"
  "[Git] Rafraichir depot local"
  "[Git] Fusion de branches"
  "[Git] Voir les branches"
  "[Git] Creer une branche"
  "[Git] Changer de branche"
  "[Git] Supprimer une branche"
  "[Git] Initialise .git/config"
  "[Git] Cloner tout mes repos"
  "Annuler"

function show_menu {
  select option in "${OPTIONS[@]}"; do
    echo $option
    break
  done
}

while true; do
  option=$(show_menu)

 if [[ $option == "Creer Nouveau Site" ]]; then
    echo "Construction d'un nouveau site"
    echo "Dans quel repertoire ? (/home/USER/simplon/jour1/)"
    read repertoire
                 
    echo "Création du répertoire ${repertoire}..."   
    echo "mkdir ${repertoire}"                       
    mkdir "${repertoire}"   
    cd  "${repertoire}"
    echo "Création de l'index.html"
    echo '<!doctype html>
    <html lang="fr">
      <head>
        <meta charset="utf-8">
        <title>Titre de la page</title>
        <link rel="stylesheet" href="style.css">
        <script src="script.js"></script>
      </head>
      <body>
        ...
        <!-- Le reste du contenu -->
        ...
      </body>
    </html>' > index.html
    echo "Création des repertoires css, scripts, img"
    mkdir {css,scripts,img}
    echo "Création des fichiers style.css et script.js"
    touch "${repertoire}/css/style.css";touch "${repertoire}/scripts/script.js"
  fi

  # =======================================
  # SELECTiON Creer un nouveau Repo GitHub
  # =======================================
  if [[ $option == "Creer Nouveau Repo GitHub" ]]; then

    echo "-Avez-vous déjà configurer Git sur ce PC ?-"
    read reponse
    if [ "$reponse" == "non" ] || [ "$reponse" == "n" ] || [ "$reponse" == "N" ]; then
	    echo "Veuillez entrer votre adresse email:"
      read email
      git config --global user.email "$email"
	    echo "Veuillez entrer votre nom d'utilisateur:"
      read username
      git config --global user.name "$username"
    fi
    repo_name=${PWD##*/}
    echo "Veuillez entrer votre identifiant Git:"
    read login
    curl -u $login https://api.github.com/user/repos -d" {\"name\":\"$repo_name\"}"
    echo "Parametrage du nouveau REPO"
    echo "- $REPO"
    touch .gitignore
    echo "# Nouveau site" >> README.md
    git init
    git add .
    git commit -m 'initial commit'
    git remote add origin "https://github.com/${login}/${repo_name}.git"
    git push -u origin master
    echo "C'est finis ! va coder"
  fi

  # =========================
  # SELECTiON COMMIT TO REMOTE
  # =========================
  if [[ $option == "[Git] Commit to remote" ]]; then
    # Started task
    echo "=> Committing to remote..."

    # Define the emailaddress used in conjuction with the SSH key to access github
    if [ -z "$SSH_KEY" ]
    then
      echo -n "Chemin complet vers la Clef SSH: "
      read SSH_KEY
      USING_DEFAULTS=false
    fi

    # Define the emailaddress used in conjuction with the SSH key to access github
    echo -n "Branch to commit to: "
    read BRANCH

    # Prompt that defaults were used
    if [ -z "$USING_DEFAULTS" ]
    then
      echo "=> Utilisation de la Clef SSH par defaut"
    fi

    # Define the select message
    echo -n "Message de commit: "
    read message

    # Add the changes to the index
    git add -A

    # Commit the changes
    git commit --interactive -m "$message"

    # Fork a copy of ssh-agent and generate Bourne shell commands on stdout
    eval $(ssh-agent -s)

    # Load the ssh key for access to Github
    ssh-add $SSH_KEY

    # Changes are currently in the HEAD of your local working copy
    # so send those changes to your remote repository
    git push origin $BRANCH

    # Kill the ssh-agent process
    pkill ssh-agent

    # Ended task
    echo "Successfully committed to remote!"
    echo "Que voulez-vous faire ensuite?"
  fi

  # ================================
  # SELECTiON Rafraichir depot local
  # ================================
  if [[ $option == "[Git] Rafraichir depot local" ]]; then
    # Prompt the user to confirm that the refresh will happen (could lose changes)
    echo -n "=> Etes-vous sûr que vous voulez rafraîchir? (o/n): "
    read CONFIRM_REFRESH

    # If we are going to refresh with remote
    if [ $CONFIRM_REFRESH == "o" ]
    then
      # Started task
      echo "=> Rafraichissement du repository local..."

       # Fork a copy of ssh-agent and generate Bourne shell commands on stdout
      eval $(ssh-agent -s)

      # Load the ssh key for access to Github
      ssh-add $SSH_KEY

      # Fetch the latest commit from remote
      git fetch origin master;

      # Kill the ssh-agent process
      pkill ssh-agent;

      # Reset to the latest commit
      git reset --hard FETCH_HEAD;

      # Clean up any excess files that are not in the latest commit
      git clean -df;

      # Ended task
      echo "Que voulez-vous faire ensuite?"
    fi

    # If we are not going to refresh
    if [ $CONFIRM_REFRESH == "n" ] ]
    then
      # Prompt that the task was cancelled
      echo "=> Annulé..."
    fi
  fi

  # ============================
  # SELECTiON Fusion de branches
  # ============================
  if [[ $option == "[Git] Fusion de branches" ]]; then
    # Define the branch to name
    echo -n "=> Fusion vers la branch: "
    read TO_BRANCH

    # Define the branch from name
    echo -n "=> Fusionner les changements depuis la branch: "
    read FROM_BRANCH

    # Switch to master
    git checkout $TO_BRANCH

    # Merge the branch into master
    git merge --squash $FROM_BRANCH

    # Ended task
    echo "Succes de la fusion $FROM_BRANCH dans $TO_BRANCH"
    echo "Que voulez-vous faire ensuite?"
  fi

  # ======================
  # SELECTiON Voir les branches
  # ======================
  if [[ $option == "[Git] Voir les branches" ]]; then
    # Show the branches
    git show-branch --list

    # Ended task
    echo "Que voulez-vous faire ensuite?"
  fi

  # ===========================
  # SELECTiON Creer une branche
  # ===========================
  if [[ $option == "[Git] Create branch" ]]; then
    # Define the branch name
    echo -n "=> Branch à creer: "
    read BRANCH

    # Create the branch
    git checkout -b $BRANCH

    # Ended task
    echo "Que voulez-vous faire ensuite?"
  fi

  # ============================
  # SELECTiON Changer de branche
  # ============================
  if [[ $option == "[Git] Changer de branche" ]]; then
    # Define the branch name
    echo -n "=> Changer de Branch pour: "
    read BRANCH

    # Switch to the branch
    git checkout $BRANCH

    # Ended task
    echo "Que voulez-vous faire ensuite?"
  fi

  # ======================
  # SELECTiON Supprimer une branche
  # ======================
  if [[ $option == "[Git] Delete branch" ]]; then
    # Define the branch name
    echo -n "=> Nom de la Branch à supprimer: "
    read BRANCH

    echo -n "=> Supprimer la branche locale: \"$BRANCH\"? (o/n): "
    read DELETE_LOCAL_BRANCH
    echo -n "=> Supprimer la branche distante: \"$BRANCH\"? (o/n): "
    read DELETE_REMOTE_BRANCH

    # Define the email address used in conjuction with the SSH key to access github
    if [ -z "$SSH_KEY" ]
    then
      echo -n "=> Chemin complet vers la Clef SSH: "
      read SSH_KEY
      USING_DEFAULTS=false
    fi

    # Prompt that defaults were used
    if [ -z "$USING_DEFAULTS" ]
    then
      echo "=> Utilisation de la Clef SSH par defaut"
    fi

    # If we are going to delete the local branch
    if [ $DELETE_LOCAL_BRANCH == "o" ]
    then
      # Started task
      echo "=> Suppression de la Branch locale..."
      # Delete the local branch
      git branch -D $BRANCH
    fi

    # If we are going to delete the remote branch
    if [ $DELETE_REMOTE_BRANCH == "y" ]
    then
      # Started task
      echo "=> Suppression de la branch distante..."

      # Fork a copy of ssh-agent and generate Bourne shell commands on stdout
      eval $(ssh-agent -s)

      # Load the ssh key for access to Github
      ssh-add $SSH_KEY

      # Delete the remote branch
      git push origin --delete $BRANCH

      # Kill the ssh-agent process
      pkill ssh-agent
    fi

    # If both options were no
    if [ $DELETE_LOCAL_BRANCH == "n" ] && [ $DELETE_REMOTE_BRANCH == "n" ]
    then
      # Prompt that the task was cancelled
      echo "=> Annulé..."
    fi

    # Ended task
    echo "Que voulez-vous faire ensuite?"
  fi

  # ===========================
  # SELECTiON INITIALISE CONFIG
  # ===========================
  if [[ $option == "[Git] Initialise .git/config" ]]; then
    # Started task
    echo "=> Initialisation .git/config..."

    # Define the name used to create the repository on Github
    if [ -z "$REPO_NAME" ]
    then
      echo -n "Nom du Repository: "
      read REPO_NAME
      # Trigger using defaults prompt
      USING_DEFAULTS=false
    fi

    # Define the username used in conjuction with the email address for Github collaborators
    if [ -z "$USER_NAME" ]
    then
      echo -n "Nom d'utilisateur Github: "
      read USER_NAME
      USING_DEFAULTS=false
    fi

    # Define the emailaddress used in conjuction with the SSH key to access github
    if [ -z "$USER_EMAIL" ]
    then
      echo -n "Adresse email: "
      read USER_EMAIL
      USING_DEFAULTS=false
    fi

    # Prompt that defaults were used
    if [ -z "$USING_DEFAULTS" ]
    then
      echo "=> Utilisation des constantes par defaut"
    fi

    # Echo in the basic configuration for git to use
    echo "[core]
      repositoryformatversion = 0
      filemode = true
      bare = false
      logallrefupdates = true
[remote \"origin\"]
      url = git@github.com:$USER_NAME/$REPO_NAME.git
      fetch = +refs/heads/*:refs/remotes/origin/*
[branch \"master\"]
      remote = origin
      merge = refs/heads/master
[user]
      name = $USER_NAME
      email = $USER_EMAIL" > .git/config

    # Ended task
    echo "=> .git/config initialisé"
    echo "Que voulez-vous faire ensuite?"
fi

  # ===============================
  # SELECTiON Cloner tout mes repos
  # ===============================
  if [[ $option == "Cloner tout mes repos" ]]; then
    echo "Votre nom d'utilisateur:"
    read repoURL
    githubBaseUrl="https://github.com";
    tempLocation=`pwd`/temp;
    tempFile="data"
    echo "INFO:: Check des fichiers temporaires."
    if [ ! -d $tempLocation ]
      then
      mkdir $tempLocation;
      mkdir "repositories";
    else
      rm $tempLocation/*;
    fi

    curlClient=`which curl`
    if [[ $curlClient = "" ]] 
      then
      echo "ERREUR:: Veuillez installer curlClient.";
    else
      echo $githubBaseUrl"/"$repoUrl"?tab=repositories";
      # curl -I $githubBaseUrl"/"$repoUrl"?tab=repositories" | awk '/HTTP/ {print $2}'
      curl $githubBaseUrl"/"$repoUrl"?tab=repositories" > $tempLocation/$tempFile;
      sed -n '/codeRepository">/,/<\/a>/p' $tempLocation/$tempFile |  sed -e 's/<\/a>$//g;/">/d;s/ //g' > $tempLocation"/repoList";
    
      if [ ! -d "repositories"/$repoUrl ]
        then
        mkdir "repositories"/$repoUrl;
      fi
    
      gitClient=`which git`;
      if [[ $gitClient = "" ]]
        then
        echo "ERREUR:: Veuillez installer le client Git";
        exit 0;
      fi
      cd $(pwd)/"repositories"/$repoUrl;
      while IFS= read -r repo
      do
        echo "$repo";
        if [ ! -d $repo ]
          then
          echo $(pwd);
          #echo "svn co $githubBaseUrl/$repoUrl/$repo.git"
          git clone $githubBaseUrl/$repoUrl/$repo.git;
        else
          git pull $githubBaseUrl/$repoUrl/$repo.git; 
        fi 
      done < "$tempLocation/repoList" 
    fi
  fi

  # =================
  # SELECTiON ANNULER
  # =================
  if [[ $option == "Annuler" ]]; then
    break
  fi

  # =====================================
  # INPUT WAS NOT WITHIN RANGE OF OPTIONS
  # =====================================
  # if [ !$option == "Commit to remote" ] &&
  #      [ !$option == "Refresh local" ] &&
  #      [ !$option == "Merge branches" ] &&
  #      [ !$option == "Show branches" ] &&
  #      [ !$option == "Create branch" ] &&
  #      [ !$option == "Switch to branch" ] &&
  #      [ !$option == "Delete branch" ] &&
  #      [ !$option == "Initialise .git/config" ] &&
  #      [ !$option == "Cancel" ]; then
  #   echo "Invalid option selected!"
  # fi

done