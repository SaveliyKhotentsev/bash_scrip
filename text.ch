#!/bin/bash

show_users() {
    echo "Список пользователей и их домашние директории:"
    getent passwd | cut -d: -f1,6 | sort
}

show_processes() {
    echo "Список запущенных процессов:"
    ps -eo pid,cmd --sort=pid
}

show_help() {
    echo "Справка:"
    echo "-u, --users: выводит список пользователей и их домашние директории, отсортированные по алфавиту."
    echo "-p, --processes: выводит список запущенных процессов, отсортированных по их идентификатору."
    echo "-l PATH, --log PATH: выводит результат в файл по указанному пути."
    echo "-e PATH, --errors PATH: выводит ошибки в файл по указанному пути."
    echo "-h, --help: выводит эту справку."
}

log_output() {
    local path=$1
    if [[ -e "$path" ]]; then
        echo "Файл $path уже существует."
    else
        echo "Вывод будет направлен в файл: $path"
        exec &> "$path"
    fi
}

redirect_errors() {
    local path=$1
    if [[ -e "$path" ]]; then
        echo "Файл $path уже существует."
    else
        echo "Ошибки будут направлены в файл: $path"
        exec 2> "$path"
    fi
}

while getopts ":u:p:l:e:h" opt; do
    case ${opt} in
        u|--users)
            show_users
            ;;
        p|--processes)
            show_processes
            ;;
        l|--log)
            log_output "$OPTARG"
            ;;
        e|--errors)
            redirect_errors "$OPTARG"
            ;;
        h|--help)
            show_help
            exit 0
            ;;
        \?)
            echo "Неверный аргумент: $OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Отсутствует аргумент для опции: $OPTARG" >&2
            exit 1
            ;;
    esac
done
