if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_vi_key_bindings

    bind --mode insert \eh backward-char
    bind --mode insert \ej down-or-search
    bind --mode insert \ek up-or-search
    bind --mode insert \el forward-char

    source ~/.sh

    function fish_greeting; sh-greeting; end

    function fish_prompt
        # user
        if functions -q fish_is_root_user; and fish_is_root_user
            set_color -o red
        else
            set_color -o green
        end
        printf '%s\e[0m' $USER
        # host
        echo -n '@'
        if test -z "$SSH_CLIENT"
            if test (prompt_hostname) = 'satokoi'
                printf '\e[1;38;5;120msato\e[1;38;5;70mkoi'
            else
                printf '\e[1;34m%s' (prompt_hostname)
            end
        else
            printf '\e[1;36m%s' (prompt_hostname)
        end
        set_color normal
        # working directory
        printf ' \e[37m%s\n\e[0m' (string replace -r "^$HOME" '~' "$PWD")
        # jobs
        for job in (jobs)
            echo "│ $job"
        end
        printf '╰->\033[0m $ '
    end

    function fish_mode_prompt
        switch $fish_bind_mode
            case default
                #_wrapper 13 10 'NORMAL'
                printf '\e[1;38;5;%d;48;5;%dm %s \e[0m' 13 10 'NORMAL'
            case insert
                printf '\e[1;38;5;%d;48;5;%dm %s \e[0m' 12 11 'INSERT'
            case replace_one
                printf '\e[1;38;5;%d;48;5;%dm %s \e[0m' 14 22 'REPLACE'
            case replace
                printf '\e[1;38;5;%d;48;5;%dm %s \e[0m' 14 9 'REPLACE'
            case visual
                printf '\e[1;38;5;%d;48;5;%dm %s \e[0m' 9 14 'VISUAL'
        end
        printf ' '
    end

    # print start time, end time, elapsed time
    function fishu_fish_preexec -e fish_preexec
        set -g fishu_start_time $(date '+%s.%N')
    end
    function fishu_fish_postexec -e fish_postexec
        set -g fishu_end_time $(date '+%s.%N')
        set -f str (string trim "$argv")
        if test "$str" = 'clear'; or test "$str" = 'ce'
        or test (string match -r '^ls' "$str")
        or test (string match -r '^cd' "$str")
        or test (string match -r '^sh-greeting' "$str")
            return
        end
        set -f elapsed (math $fishu_end_time - $fishu_start_time)
        echo -e '\e[1;32m#############################\e[0m'
        echo $argv
        echo -e '\e[1;32m#############################\e[0m'
        echo $(date --date="@$fishu_start_time" '+%Y/%m/%d %H:%M:%S.%N')
        echo $(date --date="@$fishu_end_time" '+%Y/%m/%d %H:%M:%S.%N')
        printf '\e[1m%10d %s\n' \
            (math floor $elapsed / 86400) \
            $(date --utc --date="@$elapsed" '+%H:%M:%S.%N')
        echo -e '\e[1;32m#############################\e[0m'
    end

    # ranger
    function e
        ranger
        set -f d $(ranger-cd)
        test -n "$d" && cd "$d"
    end
end
