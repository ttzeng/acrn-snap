# Snap packaging for ACRN

## Introduction

The purpose of this repository is to hold files needed to create snap packages for ACRN. There are three types of snaps needed to bring up ACRN on Ubuntu Core
* Regular snap: with the user-space components such as `acrn-dm` and other tools
* Gadget snap: Grub configuration (multiboot2) and `acrn.bin` binary
* Kernel snap: based on the kernels hosted in the `projectacrn/acrn-kernel` repo

**This is very much work in progress**

## Configuration

The initial baseline for this work consists of the following components:
* Hardware platform: NUC7i7DNB
* ACRN master (leading up to v2.4)
* Ubuntu Core 20



