# ==========================================
# LLM aliases
# ==========================================
export ANTHROPIC_BASE_URL="${ANTHROPIC_BASE_URL:-http://127.0.0.1:8080}"
export ANTHROPIC_MODEL="${ANTHROPIC_MODEL:-default}"

_LLM_USAGES="default coding reviewing reasoning fast longctx"

# ==========================================
# 输入校验
# ==========================================
_llm_validate() {
    local input="$1"

    if [ -z "$input" ]; then
        echo "❌ 请指定用途" >&2
        llm-list
        return 1
    fi

    if ! echo "$_LLM_USAGES" | grep -qw "$input"; then
        echo "❌ 无效别名: '$input'" >&2
        local suggest
        suggest=$(echo "$_LLM_USAGES" | tr ' ' '\n' \
            | grep -i "^${input:0:2}" | head -1)
        [ -n "$suggest" ] && echo "   是否想输入: $suggest ?" >&2
        return 1
    fi

    return 0
}

# 指定使用模型
llm-use() {
    _llm_validate "$1" || return 1
    export ANTHROPIC_MODEL="$1"
    echo "✅ → $ANTHROPIC_MODEL"
}

# 列出所有可用模型
llm-list() {
    echo "Available usages:"
    for u in $_LLM_USAGES; do
        local mark=""
        [ "$u" = "$ANTHROPIC_MODEL" ] && mark=" ◀"
        echo "  $u$mark"
    done
}

# 快捷切换
for _u in $_LLM_USAGES; do
    eval "llm-${_u}() { llm-use ${_u}; }"
done
unset _u

# ==========================================
# Tab 补全
# ==========================================
_llm_complete() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=($(compgen -W "$_LLM_USAGES" -- "$cur"))
}

if [ -n "$BASH_VERSION" ]; then
    complete -F _llm_complete llm-use
fi

if [ -n "$ZSH_VERSION" ]; then
    _llm_complete_zsh() {
        local -a usages
        usages=(${=_LLM_USAGES})
        _describe 'usage' usages
    }
    compdef _llm_complete_zsh llm-use
fi
