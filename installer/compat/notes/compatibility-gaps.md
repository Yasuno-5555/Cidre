# Compatibility Gaps Report

This document outlines structural blockers between Cidre's definitions and upstream Asahi installer requirements.

## 1. Seed Image Archive Format
- **Description**: Cidre packs rootfs as single `.tar.zst` files.
- **Risk**: Upstream installers may enforce multi-part split layers or rootfs images formats.
- **Solution**: Study target validation formats before forking real code blocks.

## 2. Relative URLs
- **Description**: Cidre specifies absolute `url` paths. Upstream may expect relative layout offsets from repository base roots.
- **Solution**: Apply path rewrites during adapter transformations phases.
