if ! (cd app-folder && gcloud compute scp ./backend.py andreikosz_96@my-instance-2: --zone=us-central1-a); then
    echo "Could not copy file to the VM instance " && exit 1
else
    echo "Files deployed to VM instance"
fi