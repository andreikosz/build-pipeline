if ! ls . && docker run gcr.io/terraform-265913/terraform-dns ${1}; then
    echo "Could not create DNS entry" && exit 1
else
    echo "DNS Entry created" 
fi