# Atualiza o conteudo do projeto e sincroniza com o GitHub.
#
# Uso:
#   .\scripts\atualizar_vscode.ps1                  -> usa mensagem de commit padrao (data/hora)
#   .\scripts\atualizar_vscode.ps1 "minha mensagem" -> usa a mensagem informada
#
# O script: sincroniza com o remoto, comita mudancas locais, envia para a
# branch atual e, ao final, integra/limpa branches ja mergeadas na main.
# Funciona tanto quando o merge do PR e feito fora (GitHub web) quanto
# quando voce opta por mergear daqui via gh (sempre com confirmacao).

param(
    [string]$Mensagem
)

$ErrorActionPreference = "Stop"

# Garante que estamos na raiz do repositorio (pasta acima de scripts/)
$raiz = Split-Path -Parent $PSScriptRoot
Set-Location $raiz

$branch = git branch --show-current
Write-Host "Branch atual: $branch" -ForegroundColor Cyan

# 1. Busca o estado mais recente do remoto
git fetch --all --prune

# 2. Mostra a situacao atual
git status -sb

# 3. Traz origin/main para a branch atual (fast-forward; nunca destrutivo)
#    Fast-forward apenas: se a branch atual tiver commits que divergem de
#    origin/main, o git recusa a atualizacao e nada e reescrito nem perdido.
#    Nesse caso seria necessario um merge normal (nao FF) - o script segue.
Write-Host "Trazendo origin/main para a branch atual (fast-forward)..." -ForegroundColor Cyan
git merge --ff-only origin/main

# 4. Comita mudancas locais (se houver)
$alteracoes = git status --porcelain
if ($alteracoes) {
    if (-not $Mensagem) {
        $Mensagem = "Atualiza conteudo - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    }
    git add -A
    git commit -m $Mensagem
    Write-Host "Commit criado: $Mensagem" -ForegroundColor Green
} else {
    Write-Host "Nenhuma alteracao local para commitar." -ForegroundColor Yellow
}

# 5. Traz e mescla o que houver no remoto (fast-forward quando possivel)
git merge origin/$branch

# 6. Envia para o remoto
git push -u origin HEAD

# 7. Integracao da branch atual com a main
#    Funciona nos dois fluxos de merge:
#    (a) Merge ja feito fora (GitHub web): o script detecta (pelo grafo ou
#        pelo estado do PR no GitHub) e apenas limpa local/remoto.
#    (b) Merge daqui: se houver trabalho pendente, oferece criar/mergear o
#        PR via gh, sempre com confirmacao explicita (Enter = nao, mantem
#        o fluxo de mergear depois no GitHub). O merge continua sendo via
#        PR e feito pelo autor - a main nunca recebe push direto daqui.
if ($branch -ne "main") {
    # A branch ja esta toda em origin/main? (cobre merge normal feito fora)
    git merge-base --is-ancestor $branch origin/main
    $integrada = ($LASTEXITCODE -eq 0)

    # Confere o estado do PR no GitHub (cobre merge por squash/rebase,
    # cujos commits reescritos nao sao ancestrais de origin/main)
    if (-not $integrada) {
        $estadoPr = gh pr view $branch --json state --jq .state
        if ($LASTEXITCODE -ne 0) { $estadoPr = "NENHUM" }

        if ($estadoPr -eq "MERGED") {
            $integrada = $true
        } elseif ($estadoPr -eq "OPEN") {
            $resp = Read-Host "PR aberto para '$branch'. Mergear agora via gh? (s/N)"
            if ($resp -eq "s") {
                gh pr merge $branch --merge --delete-branch
                git fetch --all --prune
                $integrada = $true
            }
        } else {
            $resp = Read-Host "Sem PR para '$branch'. Criar PR e mergear agora? (s/N)"
            if ($resp -eq "s") {
                gh pr create --fill
                gh pr merge $branch --merge --delete-branch
                git fetch --all --prune
                $integrada = $true
            }
        }
    }

    if ($integrada) {
        Write-Host "Branch $branch ja integrada a main; limpando..." -ForegroundColor Cyan
        git switch main
        git pull --ff-only origin main
        if (git branch --list $branch) { git branch -D $branch }
        $branch = "main"
    } else {
        Write-Host "Branch $branch mantida (aguardando merge do PR)." -ForegroundColor Yellow
    }
}

# 8. Limpa as demais branches ja integradas a origin/main
#    Ao final sobram so main e origin/main. Branches com commits proprios
#    (PR em aberto) sao mantidas: a checagem merge-base garante que nada
#    nao-integrado e apagado. A main local so e avancada (fast-forward);
#    nunca recebe push.
Write-Host "Limpando demais branches ja integradas a origin/main..." -ForegroundColor Cyan

# 8a. Avanca a main local ate origin/main (se nao for a branch atual)
if ($branch -ne "main") {
    git fetch . origin/main:main
}

# 8b. Apaga branches locais ja integradas
$locais = git for-each-ref --format='%(refname:short)' refs/heads/
foreach ($b in $locais) {
    if ($b -eq "main" -or $b -eq $branch) { continue }
    git merge-base --is-ancestor $b origin/main
    if ($LASTEXITCODE -eq 0) {
        git branch -d $b
        Write-Host "  Branch local $b apagada (ja integrada)." -ForegroundColor Green
    } else {
        Write-Host "  Branch local $b tem commits proprios (PR em aberto?); mantida." -ForegroundColor Yellow
    }
}

# 8c. Apaga branches remotas ja integradas
$remotas = git for-each-ref --format='%(refname:strip=3)' refs/remotes/origin/
foreach ($b in $remotas) {
    if ($b -eq "main" -or $b -eq "HEAD" -or $b -eq $branch) { continue }
    git merge-base --is-ancestor origin/$b origin/main
    if ($LASTEXITCODE -eq 0) {
        git push origin --delete $b
        Write-Host "  Branch remota $b apagada (ja integrada)." -ForegroundColor Green
    } else {
        Write-Host "  Branch remota $b tem commits proprios (PR em aberto?); mantida." -ForegroundColor Yellow
    }
}

Write-Host "Sincronizacao concluida com sucesso." -ForegroundColor Green
