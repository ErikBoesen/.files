# Export environment variables into the current shell that can be used by the awscli
# or other applications that respond to standard AWS configuration.
#
# Parameters:
#
# --profile - The named AWS profile to use. Defaults to "dev" unless $HOME/.aws/default_profile
#             exists, in which case that value is used when --profile is not supplied.
# --role-session-name - If profile uses role assumption, then name for session. Defaults to
#                       current user name.
# --duration-seconds - Duration of a session when using role assumption. Defaults to 3600.
#
function awsenv {
    local region
    local profile
    local key
    local secret
    local token
    local role_arn
    local source_profile
    local session
    local duration
    local creds
    local expiration
    local consumed_arg

    profile="dev"
	if [ -e $HOME/.aws/default_profile ]; then
        profile="$(cat $HOME/.aws/default_profile)"
	fi

    session="$(id -un)"
    duration=3600
    consumed_arg=1

    for arg in "$@"; do
        shift
        case "$arg" in
            "--profile")
                profile="$1"
                consumed_arg=0
                ;;
            "--role-session-name")
                session="$1"
                consumed_arg=0
                ;;
            "--duration-seconds")
                duration="$1"
                consumed_arg=0
                ;;
            *)
                if [ $consumed_arg -eq 1 ]; then
                    set -- "$@" "$arg"
                fi
                consumed_arg=1
        esac
    done

    if [ ! -f $(command -v jq) ]; then
        (>&2 echo "ERROR: jq must be intalled for 'awsenv' to work")
        return
    fi

    region="$(aws configure get region --profile ${profile})"
    source_profile="$(aws configure get source_profile --profile ${profile})"
    role_arn="$(aws configure get role_arn --profile ${profile})"

    # Handle role assumption with temporary credentials if necessary, otherwise just
    # pull the key and secret from the extant configuration.
    if [ -n "$source_profile" ]; then
        if [ -z "$role_arn" ]; then
            (>&2 echo "ERROR: Must specify a role_arn if using a source_profile in $profile")
            return
        fi

        creds=$(aws sts assume-role --role-arn $role_arn --profile $profile --role-session-name $session --duration-seconds $duration)
        if [ $? -ne 0 ]; then
            (>&2 echo "ERROR: Could not assume role $role_arn")
            return
        fi

        key=$(echo "$creds" | jq -r .Credentials.AccessKeyId)
        secret=$(echo "$creds" | jq -r .Credentials.SecretAccessKey)
        token=$(echo "$creds" | jq -r .Credentials.SessionToken)
        expiration=$(echo "$creds" | jq -r .Credentials.Expiration)

        echo "WARNING: Assumed credentials expire at $expiration"
    else
        key="$(aws configure get aws_access_key_id --profile ${profile})"
        secret="$(aws configure get aws_secret_access_key --profile ${profile})"
    fi

    # Ensure the environment variables are set
	export AWS_DEFAULT_PROFILE=${profile}
	export AWS_DEFAULT_REGION=${region}
    export AWS_REGION=${region}
	export AWS_ACCESS_KEY_ID=${key}
	export AWS_SECRET_ACCESS_KEY=${secret}
    export AWS_SESSION_TOKEN=${token}
}

function awsc {
	if [ -z $1 ]; then
		echo "AWS default env is ${AWS_DEFAULT_PROFILE}"
		return
	fi
	echo $1 > $HOME/.aws/default_profile

	if [ -n "$2" ]; then
		(awsenv && $(which aws) "${@:2}")
	else
		awsenv
	fi
}
