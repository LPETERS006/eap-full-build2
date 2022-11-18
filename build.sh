for d in */
do
    iv=$(echo -n $d | head -c -1)
    (cd "$d" && docker buildx build --platform linux/amd64,linux/arm64 --label "eap-full-ci2(arm64,amd64)" --tag lpeters999/eap-full-ci2:$iv --force-rm --no-cache --push . && \
		docker buildx build --platform linux/amd64,linux/arm64 --label "eap-full-ci2(arm64,amd64)" --tag lpeters999/eap-full-ci2:latest-$iv --force-rm --no-cache --push .)
done
