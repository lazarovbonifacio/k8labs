# K8labs com K0S

## Objetivo

Subir uma distribuições kubernetes para testes

# Tecnologias utilizadas

- OpenTofu v1.9.1
- libvirt com qemu/kvm
- virsh
- K0S
- Debian Bookworm

## Justificativa

Inicialmente, tentei subir esse lab com LXC, mas como precisava fazer alterações no kernel do host eu optei por subir em uma VM.

A escolha do opentofu foi puramente arbitrária, terraform também serviria igual.

O debian é um distribuição bem robusta para servidores, e como eu precisava de algo para funcionar rápido e em qualquer lugar, optei pela imagem em nuvem. Desta forma não é necessário baixar nada.

Como não será necessario interface gráfica, o virsh vai ser de bom tamanho.

Preferi utilizar o K0S pela proposta multiplataforma e pela simplicidade dele. Poderia ter usado o microk8s, mas eu particularmente não sou fã da canonical e nem queira instalar os snaps

# Comandos

Para inicializar a máquina: `sudo virsh start k0s`
Para acessar a console da máquina: `sudo virsh console k0s`
Primeiro comando ao iniciar a sessão: `sudo k0s kubectl get nodes`
