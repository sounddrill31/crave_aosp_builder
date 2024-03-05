# Create the upload directory if it doesn't exist
mkdir -p upload || true

# Move the files only if they exist
for file in recovery.img boot.img vendor_boot.img vendor.img system.img; do
    if [ -e "${GITHUB_WORKSPACE}/${GITHUB_EVENT_INPUTS_DEVICE_NAME}/${file}" ]; then
        mv "${GITHUB_WORKSPACE}/${GITHUB_EVENT_INPUTS_DEVICE_NAME}/${file}" "upload/${file}" || true
    fi
done

# Move the zip files
mv "${GITHUB_WORKSPACE}/${GITHUB_EVENT_INPUTS_DEVICE_NAME}/*.zip" "upload/" || true

# Create the GitHub release
gh release create "${GITHUB_RUN_ID}" "upload/*" -t "Release ${GITHUB_EVENT_INPUTS_PRODUCT_NAME}-${GITHUB_RUN_ID}" -n "${GITHUB_EVENT_INPUTS_PRODUCT_NAME}-${GITHUB_RUN_ID}" || true
