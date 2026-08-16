import type { ExtensionAPI, ExtensionCommandContext, SessionEntry } from "@earendil-works/pi-coding-agent";
import { Text, truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";
import { homedir } from "node:os";
import { isAbsolute, relative, resolve, sep } from "node:path";

const STATS_ENTRY = "token-stats";

function formatTokens(count: number): string {
	if (count < 1000) return count.toString();
	if (count < 10000) return `${(count / 1000).toFixed(1)}k`;
	if (count < 1_000_000) return `${Math.round(count / 1000)}k`;
	if (count < 10_000_000) return `${(count / 1_000_000).toFixed(1)}M`;
	return `${Math.round(count / 1_000_000)}M`;
}

function formatCwd(cwd: string): string {
	const home = homedir();
	const resolvedCwd = resolve(cwd);
	const resolvedHome = resolve(home);
	const relativeToHome = relative(resolvedHome, resolvedCwd);
	const isInsideHome =
		relativeToHome === "" ||
		(relativeToHome !== ".." && !relativeToHome.startsWith(`..${sep}`) && !isAbsolute(relativeToHome));
	if (!isInsideHome) return cwd;
	return relativeToHome === "" ? "~" : `~${sep}${relativeToHome}`;
}

function collectUsage(entries: SessionEntry[]) {
	const totals = { input: 0, output: 0, cacheRead: 0, cacheWrite: 0, cost: 0 };
	let latestCacheHitRate: number | undefined;

	for (const entry of entries) {
		if (entry.type === "message" && entry.message.role === "assistant") {
			const usage = entry.message.usage;
			totals.input += usage.input;
			totals.output += usage.output;
			totals.cacheRead += usage.cacheRead;
			totals.cacheWrite += usage.cacheWrite;
			totals.cost += usage.cost.total;
			const promptTokens = usage.input + usage.cacheRead + usage.cacheWrite;
			latestCacheHitRate = promptTokens > 0 ? (usage.cacheRead / promptTokens) * 100 : undefined;
		} else if (entry.type === "message" && entry.message.role === "toolResult" && entry.message.usage) {
			const usage = entry.message.usage;
			totals.input += usage.input;
			totals.output += usage.output;
			totals.cacheRead += usage.cacheRead;
			totals.cacheWrite += usage.cacheWrite;
			totals.cost += usage.cost.total;
		} else if ((entry.type === "branch_summary" || entry.type === "compaction") && entry.usage) {
			const usage = entry.usage;
			totals.input += usage.input;
			totals.output += usage.output;
			totals.cacheRead += usage.cacheRead;
			totals.cacheWrite += usage.cacheWrite;
			totals.cost += usage.cost.total;
		}
	}

	return { totals, latestCacheHitRate };
}

function buildStatsLine(ctx: ExtensionCommandContext): string {
	const { totals, latestCacheHitRate } = collectUsage(ctx.sessionManager.getEntries());
	const parts: string[] = [];

	if (totals.input) parts.push(`↑${formatTokens(totals.input)}`);
	if (totals.output) parts.push(`↓${formatTokens(totals.output)}`);
	if (totals.cacheRead) parts.push(`R${formatTokens(totals.cacheRead)}`);
	if (totals.cacheWrite) parts.push(`W${formatTokens(totals.cacheWrite)}`);
	if ((totals.cacheRead > 0 || totals.cacheWrite > 0) && latestCacheHitRate !== undefined) {
		parts.push(`CH${latestCacheHitRate.toFixed(1)}%`);
	}
	if (totals.cost) parts.push(`$${totals.cost.toFixed(3)}`);

	const context = ctx.getContextUsage();
	if (context) {
		const window = formatTokens(context.contextWindow);
		parts.push(context.percent === null ? `?/${window}` : `${context.percent.toFixed(1)}%/${window}`);
	}

	if (ctx.model) {
		const thinking = ctx.thinkingLevel && ctx.thinkingLevel !== "off" ? ` • ${ctx.thinkingLevel}` : "";
		parts.push(`${ctx.model.id}${thinking}`);
	}

	return parts.join(" ") || "No usage yet";
}

function applySlimFooter(ctx: ExtensionCommandContext): void {
	ctx.ui.setFooter((tui, theme, footerData) => {
		const unsub = footerData.onBranchChange(() => tui.requestRender());
		return {
			dispose: unsub,
			invalidate() {},
			render(width: number): string[] {
				let pwd = formatCwd(ctx.sessionManager.getCwd());
				const branch = footerData.getGitBranch();
				if (branch) pwd = `${pwd} (${branch})`;
				const sessionName = ctx.sessionManager.getSessionName();
				if (sessionName) pwd = `${pwd} • ${sessionName}`;

				const model = ctx.model?.id ?? "";
				const left = theme.fg("dim", pwd);
				const right = model ? theme.fg("dim", model) : "";
				const pad = " ".repeat(Math.max(1, width - visibleWidth(left) - visibleWidth(right)));
				const lines = [truncateToWidth(left + pad + right, width, theme.fg("dim", "..."))];

				const statuses = footerData.getExtensionStatuses();
				if (statuses.size > 0) {
					const statusLine = Array.from(statuses.entries())
						.sort(([a], [b]) => a.localeCompare(b))
						.map(([, text]) => text.replace(/[\r\n\t]/g, " ").replace(/ +/g, " ").trim())
						.join(" ");
					lines.push(truncateToWidth(statusLine, width, theme.fg("dim", "...")));
				}

				return lines;
			},
		};
	});
}

export default function (pi: ExtensionAPI) {
	pi.registerEntryRenderer<{ line: string }>(STATS_ENTRY, (entry, _options, theme) => {
		return new Text(theme.fg("dim", entry.data?.line ?? "No usage yet"), 1, 0);
	});

	pi.on("session_start", (_event, ctx) => {
		if (ctx.mode === "tui") applySlimFooter(ctx);
	});

	pi.registerCommand("stats", {
		description: "Show token, cache, cost, and context usage",
		handler: async (_args, ctx) => {
			pi.appendEntry(STATS_ENTRY, { line: buildStatsLine(ctx) });
		},
	});
}
