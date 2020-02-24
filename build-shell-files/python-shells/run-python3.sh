if ! (gcloud compute ssh andreikosz_96@my-instance-2 --zone=us-central1-a --command="python backend.py 2 > output.txt &");then
    echo "Could not run pytho app" && exit 1
else
    echo "App is running on VM external IP port 8080"
fi