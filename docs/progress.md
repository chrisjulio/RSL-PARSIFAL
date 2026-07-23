# progress.md — Estado de progresso das sessões

> **Instrução ao agente:** No início de cada sessão, leia **apenas a seção "Estado
> atual"** deste arquivo (`leia a seção "Estado atual" de docs/progress.md e continue
> de onde paramos`) — **não** o arquivo inteiro. Atualize o "Estado atual" ao final de
> cada sessão produtiva.
>
> **Onde está o estado de retomada — leia SÓ o topo.** Na retomada, leia **apenas a
> seção "Estado atual"** (logo abaixo): ela resume fase/tarefa vigente, último/próximo
> passo, bloqueios e decisões. O **Histórico** mais abaixo é referência e **só deve ser
> consultado sob demanda** (`Grep`/paginação) — não o carregue inteiro, para evitar
> poluição de contexto com itens já tratados.
>
> **Histórico e regra de corte (repaginação).** Mantenha o histórico — não apague
> entradas; adicione novas no **topo** da seção "Histórico". **Regra de transição:**
> quando este arquivo atingir **2500 linhas**, repagine — migre as entradas de
> sessão **mais antigas** para [`progress_archive.md`](progress_archive.md) (mais
> novas no topo lá também), preservando aqui a era de trabalho corrente, até voltar
> com folga abaixo de 2500. Registre data e intervalo migrado no cabeçalho do
> `progress_archive.md`.

---

## Estado atual

**Data da última atualização:** 2026-07-23

**Fase/etapa vigente:** Infraestrutura do workspace concluída; a RSL em si ainda não começou — próxima fase é a etapa 1 do protocolo (`prompt.md` §2).

**Última tarefa concluída:** Setup do workspace — CLAUDE.md, CONTRIBUTING.md e estrutura de pastas (PR #1, mergeado).

**Tarefa em tratamento:** Implantação do kit de continuidade do metacreation (progress.md, achados_divergencias.md, hooks .ps1, atualizar_vscode.ps1, .gitignore, regras novas no CLAUDE.md).

**Próxima tarefa na trilha:** Definir o protocolo da RSL em `protocolo/` — problema, questões de pesquisa, escopo, critérios de inclusão/exclusão/qualidade.

**Último passo concluído:**
- Arquivos do kit criados/copiados localmente; CLAUDE.md atualizado com início de sessão, regime de merge, cadência e armadilhas de tooling.

**Próximo passo planejado:**
- Commit + PR + merge da implantação (aguardando autorização expressa do autor); em seguida, iniciar a definição do protocolo.

**Bloqueios ativos:**
- Nenhum.

**Decisões pendentes:**
- Nenhuma.

---

## Como atualizar este arquivo

Ao final de cada sessão produtiva, atualize a seção "Estado atual" acima e
adicione uma entrada no topo do Histórico seguindo o modelo:

```markdown
### AAAA-MM-DD — Título breve da sessão

- **Concluído:** o que foi feito.
- **Próximo:** próximo passo imediato.
- **Bloqueios:** bloqueios que impedem progresso (ou "Nenhum").
- **Decisões pendentes:** pontos que precisam de validação humana (ou "Nenhuma").
```

---

## Histórico de sessões

### 2026-07-23 — Setup do workspace e implantação do kit de continuidade

- **Concluído:** git conectado a chrisjulio/RSL-PARSIFAL; CLAUDE.md, CONTRIBUTING.md e pastas de etapa (PR #1, mergeado); avaliação do metacreation e implantação do kit de continuidade (progress.md, achados_divergencias.md, hooks .ps1 de sessão, atualizar_vscode.ps1, .gitignore). Decisões: merge pelo Claude com autorização expressa; hooks em variante PowerShell (sem jq na máquina); mecanismo status.md não implantado.
- **Próximo:** commit/PR/merge da implantação; depois, etapa 1 — protocolo da RSL.
- **Bloqueios:** Nenhum.
- **Decisões pendentes:** Nenhuma.
