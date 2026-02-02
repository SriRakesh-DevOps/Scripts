# Create SSH key for your githubaccount1 and do the same for account2
$: ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_rakhi2421 -C "srirakesh242001@gmail.com"

# Check pid
$: eval "$(ssh-agent -s)" 

# Add the identity for both accounts
$: ssh-add ~/.ssh/id_ed25519_rakhi2421  

# Check the connection
$: ssh -T git@github.com

# Copy the public Key and add it in github account 
# Go to settings -> ssh key -> add ssh-key -> give a name -> pastekey and save it.
$: cat ~/.ssh/id_ed25519_rakhi2421.pub





