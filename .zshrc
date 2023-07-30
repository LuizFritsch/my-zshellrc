# Git
alias master='git checkout master'
alias pull='git pull'
alias push='git push'
alias pm='git pull origin master'
alias status='git status'
alias log='git log --all --graph --decorate --oneline --abbrev-commit'
alias pmHARD='git reset --hard HEAD && git pull' # Delete all files and pull from branch
alias lock='mob && git checkout HEAD pubspec.lock' # Goes to mob and reset lock file from last commit
alias ss='git stash save '$1'' # Stash current changes
alias sa='git stash apply'
alias saenv='git stash apply stash^{/env}'
alias sapodfile='git stash apply stash^{/podfile}'
alias prstatus='gh pr status'
alias prview='gh pr view --web'


# NPM
alias nr='npm run '$1''
alias build='npm run build'
alias sd='npm run start:dev'
# PM2
# Run project with n instances and load balance
alias nrpm='npm run pm2:start -- -i '$1' -f'
# Monitor logs from n instances
alias monit='npx pm2 monit'
# Kill n instances
alias kill='npx pm2 kill'


# Flutter
alias pack='flutter pub get'
alias clean='flutter clean'
alias getPackages='dart ./scripts/cli/cli.dart getPackages --no-cn --quick'
alias format='dart format . -l 120'
alias analyze='flutter analyze --no-fatal-infos'
alias teste='flutter test'
alias testeco='flutter test --coverage'
alias testes='flutter test --no-sound-null-safety'
alias precommitlbc='lbc && analyze && format && teste'
alias precommit='analyze && format && teste'
alias runEmulator='flutter emulators --launch Pixel_4a_API_30'
alias launch='flutter emulators --launch '$1''
alias gradcb='cd android && ./gradlew clean && ./gradlew build' # Clean and build android
alias text='adb shell input text '$1'' # Send text to emulator
alias pod='arch -x86_64 pod'


# Shell
alias projects='cd ~/Projects/'
alias upcoming='projects && cd -/feature_modules/-'
alias lbc='projects && cd -/feature_modules/-'
alias serv='projects && cd -/feature_modules/-'
alias mobserv='projects && cd -/feature_modules/-'
alias mob='projects && cd -'
alias fm='projects && cd -/feature_modules'


# Shell helper
alias editAlias='code ~/.zshrc'
alias editGit='code ~/.gitConfig'
alias openAlias='open ~/'
alias reload='source ~/.zshrc'

# Kubernets
# Use context
alias kubenot='kubectl config use-context rt/eudly/s00/-'
alias kubenot1='kubectl config use-context rt/eudly/s01/-'
alias kubenotdev='kubectl config use-context rt/eudev/s00/-'
alias kubenotint='kubectl config use-context rt/euint/s00/-'
alias kubenotprd='kubectl config use-context rt/euprd/s00/-'
alias kubenotnaprd='kubectl config use-context rt/naprd/s00/-'

# Login pod
alias kubenotification='vault login -method=oidc -path=rtac role=- && ./setup-k8s-debugger-context.sh eudly - - s00'
alias kubenotification1='vault login -method=oidc -path=rtac role=- && ./setup-k8s-debugger-context.sh eudly - - s01'
alias kubenotificationprd='vault login -method=oidc -path=rtac role=- && ./setup-k8s-debugger-context.sh euprd - - s00'
alias kubenotificationnaprd='vault login -method=oidc -path=rtac role=- && ./setup-k8s-debugger-context.sh naprd - - s00'
alias kubenotificationdev='vault login -method=oidc -path=rtac role=- && ./setup-k8s-debugger-context.sh eudev - - s00'
alias kubenotificationint='vault login -method=oidc -path=rtac role=- && ./setup-k8s-debugger-context.sh euint - - s00'

# General
alias kubepods='kubectl get pods'
alias podname='kubectl get pods --no-headers -o custom-columns=":metadata.name"'
alias kubecontexts="kubectl config get-contexts"


# sync migrations to allEnvs
syncMigrations() { 
    ARG_COUNT=1
    if [ $# -lt "$ARG_COUNT" ]; then
        echo "Usage: ${FUNCNAME[0]} <command>"
        echo "Sync migrations to allEnvs "
        return
    fi
    array=( 'kubectl config use-context rt/eudly/s00/-' 'kubectl config use-context rt/eudev/s00/-' 'kubectl config use-context rt/euint/s00/-' 'kubectl config use-context rt/euprd/s00/-' )
    for contexts in "${array[@]}"
    do
        $contexts
        pod=`podname`
        kubenpm $pod typeorm-cli:sync
    done
    if [ $? -eq 0 ]; then
        echo '-> Done.'
    else
        echo '-> Error occured.'
    fi
}


# Get command history from a specific command
h() { 
    ARG_COUNT=1
    if [ $# -lt "$ARG_COUNT" ]; then
        echo "Usage: ${FUNCNAME[0]} <command>"
        echo "Get command history from a specific command"
        return
    fi
    PR="$1"
    BASE_URL="history | grep $1"
    echo
    echo "Running '$BASE_URL'"
    echo
    history | grep $1
    if [ $? -eq 0 ]; then
        echo '-> Done.'
    else
        echo '-> Error occured.'
    fi
}


# Get env vars from a pod
kubeEnv() { 
    ARG_COUNT=1
    pod=''
    if [ $# -lt "$ARG_COUNT" ]; then
        pod=`podname`
    else
        pod=$1
    fi
    #echo "Running kubectl exec $1 -- env"
    echo "Running kubectl exec $pod -- env"
    echo
    kubectl exec $pod -- env
    if [ $? -eq 0 ]; then
        echo '-> Done.'
    else
        echo '-> Error occured.'
    fi
}


# Get logs from a pod
kubelog() { 
    ARG_COUNT=0
    pod=''
    if [ $# -lt "$ARG_COUNT" ]; then
        pod=`podname`
    else
        pod=$1
    fi
    pod=`podname`
    echo
    echo "Running kubectl logs $pod --since=$1m min"
    echo
    kubectl logs $pod --since=$1m > kubelogs1.txt
    if [ $? -eq 0 ]; then
        echo '-> Done.'
    else
        echo '-> Error occured.'
    fi
}


# Exec npm run script on a pod
kubenpm() {
    ARG_COUNT=2
    if [ $# -lt "$ARG_COUNT" ]; then
        echo "Usage: ${FUNCNAME[0]} <command>"
        echo "Exec npm run <script> on a pod"
        return
    fi
    echo
    echo "Running kubectl exec $1 npm run $2"
    echo
    kubectl exec $1 npm run $2
    if [ $? -eq 0 ]; then
        echo '-> Done.'
    else
        echo '-> Error occured.'
    fi
}


# Move up n directories 
up() { cd $(eval printf '../'%.0s {1..$1}) && pwd; }


# Creates a feature branch with `team/feature/nwap-` prefix
function cbfeat() {
    ARG_COUNT=1
    if [ $# -lt "$ARG_COUNT" ]; then
        echo "Usage: ${FUNCNAME[0]} <nwapnumber/new-branch-name>"
        echo "Creates a feature branch with 'team/feature/nwap-' prefix"
        return
    fi
    echo "Executing git checkout -b team/feature/nwap-$1"
    echo
    git checkout -b team/feature/nwap-$1
	if [ $? -eq 0 ]; then
        echo '-> Done.'
    else
        echo '-> Error occured.'
    fi
}

# Creates a feature branch with `team/fix/nwap-` prefix
function cbnt() {
    ARG_COUNT=1
    if [ $# -lt "$ARG_COUNT" ]; then
        echo "Usage: ${FUNCNAME[0]} <new-branch-name>"
        echo " Creates a feature branch with 'team/fix/noticket-' prefix"
        return
    fi
    echo "Executing git checkout -b team/fix/noticket-$1"
    echo
    git checkout -b team/fix/noticket-$1
	if [ $? -eq 0 ]; then
        echo '-> Done.'
    else
        echo '-> Error occured.'
    fi
}

# Creates a feature branch with `team/fix/nwap-` prefix
function cbfix() {
    ARG_COUNT=1
    if [ $# -lt "$ARG_COUNT" ]; then
        echo "Usage: ${FUNCNAME[0]} <nwapnumber/new-branch-name>"
        echo " Creates a feature branch with 'team/fix/nwap-' prefix"
        return
    fi
    echo "Executing git checkout -b team/fix/nwap-$1"
    echo
    git checkout -b team/fix/nwap-$1
	if [ $? -eq 0 ]; then
        echo '-> Done.'
    else
        echo '-> Error occured.'
    fi
}


# Execute git checkout
function checkout() {
    ARG_COUNT=1
    if [ $# -lt "$ARG_COUNT" ]; then
        echo "Usage: ${FUNCNAME[0]} <branch-name>"
        echo "Execute git checkout"
        return
    fi
    echo "Executing git checkout $1"
    echo
    git checkout $1
	if [ $? -eq 0 ]; then
        echo '-> Done.'
    else
        echo '-> Error occured.'
    fi
}


# Checkout branch
function cb() {
    ARG_COUNT=1
    if [ $# -lt "$ARG_COUNT" ]; then
        echo "Usage: ${FUNCNAME[0]} <branch-name>"
        echo "Checkout branch with 'team/feature/nwap' prefix"
        return
    fi
    echo "Executing git checkout team/feature/nwap-$1"
    echo
    git checkout team/feature/nwap-$1
	if [ $? -eq 0 ]; then
        echo '-> Done.'
    else
        echo '-> Error occured.'
    fi
}