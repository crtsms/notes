if [ ! -z "$CI_COMMIT_TAG" -a "$CI_COMMIT_TAG" != " " ]; then
    echo "RELEASE VERSION"
    export BUILD_ID_NAME=$CI_COMMIT_TAG
fi
if printf '%s' "$CI_COMMIT_REF_NAME"| grep -Eq '^feat/'; then
    echo "FEAT VERSION"
    export MAJOR=$(git describe --abbrev=0 | awk -F [..] '{print $1}') 
    export MINOR=$(git describe --abbrev=0 | awk -F [..] '{print $2 + 1}') 
    export PATCH=0
    export BUILD_ID_NAME=$MAJOR.$MINOR.$PATCH-feat.$CI_PIPELINE_IID
    export PRE_RELEASE=feat.$CI_PIPELINE.IID
fi
if printf '%s' "$CI_COMMIT_REF_NAME" | grep -Eq '^fix/'; then 
    echo "FIX VERSION"
    export MAJOR=$(git describe --abbrev=0 | awk -F [..] '{print $1}') 
    export MINOR-$(git describe --abbrev=0 | awk -F [..] '{print $2}')
    export PATCH=$(git describe --abbrev=0 | awk -F [..] '{print $3 + 1}')
    export BUILD_ID_NAME=$MAJOR.$MINOR.$PATCH-fix.$CI_PIPELINE_IID
    export PRE_RELEASE-fix.$CI_PIPELINE_IID
fi
if [ "$CI_COMMIT_BRANCH" == "$CI_DEFAULT_BRANCH" ]; then 
    echo "MAIN VERSION"
    export MAJOR=$(git describe --abbrev=0 | awk -F [..] '{print $1}') 
    export MINOR=$(git describe --abbrev=0 | awk -F [..] '{print $2 + 1}')
    export PATCH-0
    export BUILD_ID_NAME=$MAJOR.$MINOR.$PATCH-main.$CI_PIPELINE_IID
    export PRE_RELEASE=main.$CI_PIPELINE_IID
fi
echo BUILD_ID_NAME=$BUILD_ID_NAME >> variables.env 
echo PRE_RELEASE=$PRE_RELEASE >> variables.env 
echo $BUILD_ID_NAME
echo $PRE_RELEASE