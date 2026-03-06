#!/bin/bash

# ==========================================
# Скрипт для реструктуризации пакетов Stow
# Версия 2.0 (Vibe Coder Edition)
# ==========================================
# Превращает:   <пакет>/<файл>
# В:           <пакет>/.config/<пакет>/<файл>
# ==========================================

# 1. Определяем целевую директорию
# Если передан аргумент - используем его, иначе работаем в текущей папке
STOW_DIR="${1:-.}"

# Проверка существования директории
if [ ! -d "$STOW_DIR" ]; then
    echo "❌ Ошибка: Директория '$STOW_DIR' не найдена."
    exit 1
fi

echo "📂 Работа с директорией: $(realpath "$STOW_DIR")"
cd "$STOW_DIR" || exit 1

# 2. Цикл по всем поддиректориям
for dir in */; do
    # Убираем слэш в конце для удобства
    pkg_name=${dir%/}
    
    # Пропускаем, если это не директория
    [ -d "$pkg_name" ] || continue

    # 🛑 ИГНОРИРУЕМ _wallpapers (и другие системные папки при необходимости)
    if [ "$pkg_name" == "_wallpapers" ]; then
        echo "   ⏭️  Пропущено: $pkg_name (игнорируемая папка)"
        continue
    fi

    echo "🔍 Проверка пакета: $pkg_name"

    # 3. Проверка: есть ли внутри .config
    if [ ! -d "$pkg_name/.config" ]; then
        
        echo "   ⚙️  .config не найден. Начинаю реструктуризацию..."

        # --- Шаг А: Создать временную директорию .config ---
        mkdir -p "$pkg_name/.config"
        
        # --- Шаг Б: Переместить ВСЁ из текущей директории в .config ---
        # shopt -s dotglob нужен, чтобы захватить и скрытые файлы (начинающиеся с .)
        shopt -s dotglob
        for item in "$pkg_name"/*; do
            # Пропускаем саму папку .config и проверяем существование
            if [ -e "$item" ] && [ "$(basename "$item")" != ".config" ]; then
                mv "$item" "$pkg_name/.config/"
            fi
        done
        shopt -u dotglob

        # --- Шаг В: Создать новую директорию с именем пакета внутри .config ---
        mkdir -p "$pkg_name/.config/$pkg_name"
        
        # --- Шаг Г: Переместить содержимое .config в новую директорию ---
        shopt -s dotglob
        for item in "$pkg_name/.config"/*; do
            if [ -e "$item" ] && [ "$(basename "$item")" != "$pkg_name" ]; then
                mv "$item" "$pkg_name/.config/$pkg_name/"
            fi
        done
        shopt -u dotglob

        echo "   ✅ Готово: $pkg_name/.config/$pkg_name/"
    else
        echo "   ⏭️  Пропущено: .config уже существует."
    fi
done

echo "🎉 Завершено! Вайбы сохранены."
