import React from 'react';

// Devopstrio App Landing Zone - Platform Portal
// Features: App portfolio, Cost dashboard, Environment Status

const Dashboard = () => {
    return (
        <div className="min-h-screen bg-[#0f172a] text-slate-50 font-sans selection:bg-indigo-500/30 pb-20">
            {/* Enterprise Topbar */}
            <header className="border-b border-indigo-500/20 bg-[#0f172a] sticky top-0 z-50">
                <div className="max-w-screen-2xl mx-auto px-8 h-20 flex items-center justify-between">
                    <div className="flex items-center gap-6">
                        <div className="w-10 h-10 bg-indigo-600 rounded-lg flex items-center justify-center font-black shadow-lg shadow-indigo-600/30">ALZ</div>
                        <div>
                            <h1 className="text-xl font-bold tracking-tight text-white">App Landing Zone</h1>
                        </div>
                    </div>
                    <nav className="flex gap-8">
                        {['My Apps', 'Templates', 'Team Costs', 'Docs'].map((item) => (
                            <a key={item} href="#" className="text-sm font-bold text-slate-400 hover:text-white transition-colors">{item}</a>
                        ))}
                    </nav>
                    <div className="flex bg-slate-800 rounded-full px-4 py-1.5 items-center gap-2">
                        <div className="w-2 h-2 rounded-full bg-emerald-400"></div>
                        <span className="text-xs font-bold text-slate-300">Platform Healthy</span>
                    </div>
                </div>
            </header>

            <main className="max-w-screen-2xl mx-auto px-8 py-10 mt-6">

                {/* Header Section */}
                <div className="flex justify-between items-end mb-10">
                    <div>
                        <h2 className="text-3xl font-black text-white">Platform Overview</h2>
                        <p className="text-slate-400 mt-2 text-sm">Manage your deployed applications, environments, and quotas.</p>
                    </div>
                    <button className="bg-indigo-600 hover:bg-indigo-500 text-white font-bold py-3 px-6 rounded-xl transition-all shadow-lg flex items-center gap-2">
                        + Provision New App
                    </button>
                </div>

                {/* KPI Cards */}
                <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-12">
                    {[
                        { label: 'Active Environments', value: '24', detail: 'Prod: 8 | Non-Prod: 16' },
                        { label: 'Platform Uptime', value: '99.98%', detail: 'Last 30 Days' },
                        { label: 'Team Monthly Spend', value: '£1,840', detail: '82% of £2.5k Budget', warning: true },
                        { label: 'Security Alerts', value: '0', detail: 'Container Scans Passed' }
                    ].map((idx) => (
                        <div key={idx.label} className="bg-slate-800/50 p-6 rounded-2xl border border-slate-700 hover:border-indigo-500/50 transition-colors">
                            <div className="text-xs font-bold uppercase tracking-wider text-slate-400">{idx.label}</div>
                            <div className={`text-4xl font-black mt-2 ${idx.warning ? 'text-amber-400' : 'text-white'}`}>{idx.value}</div>
                            <div className="text-xs mt-2 text-slate-500">{idx.detail}</div>
                        </div>
                    ))}
                </div>

                {/* Application Portfolio Table */}
                <div className="bg-slate-800/40 rounded-2xl border border-slate-700 overflow-hidden">
                    <div className="p-6 border-b border-slate-700 flex justify-between items-center">
                        <h3 className="font-bold text-lg text-white">My Application Portfolio</h3>
                        <input type="text" placeholder="Search apps..." className="bg-slate-900 border border-slate-700 rounded-lg px-4 py-2 text-sm text-white focus:outline-none focus:border-indigo-500" />
                    </div>
                    <table className="w-full text-left border-collapse">
                        <thead>
                            <tr className="bg-slate-900/50 text-slate-400 text-xs uppercase tracking-wider">
                                <th className="p-4 font-bold border-b border-slate-700">Application</th>
                                <th className="p-4 font-bold border-b border-slate-700">Template Used</th>
                                <th className="p-4 font-bold border-b border-slate-700">Environments</th>
                                <th className="p-4 font-bold border-b border-slate-700">Last Deploy</th>
                                <th className="p-4 font-bold border-b border-slate-700 text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody className="text-sm text-slate-300">
                            {[
                                { name: 'Payments Gateway', tpl: 'FastAPI Backend', envs: ['Dev', 'Test', 'Prod'], deploy: 'Today, 09:42' },
                                { name: 'Customer Dashboard', tpl: 'Next.js Frontend', envs: ['Dev', 'Prod'], deploy: 'Yesterday, 14:15' },
                                { name: 'Order Sync Worker', tpl: 'Python CronJob', envs: ['Test'], deploy: '3 days ago' },
                            ].map((app) => (
                                <tr key={app.name} className="hover:bg-slate-700/30 border-b border-slate-700/50 transition-colors">
                                    <td className="p-4 font-bold text-white">{app.name}</td>
                                    <td className="p-4"><span className="bg-slate-700 px-2 py-1 rounded text-xs">{app.tpl}</span></td>
                                    <td className="p-4 flex gap-2">
                                        {app.envs.map(e => (
                                            <span key={e} className={`text-[10px] uppercase font-bold px-2 py-1 rounded ${e === 'Prod' ? 'bg-indigo-500/20 text-indigo-400' : 'bg-slate-600/50 text-slate-300'}`}>{e}</span>
                                        ))}
                                    </td>
                                    <td className="p-4 text-slate-400">{app.deploy}</td>
                                    <td className="p-4 text-right">
                                        <button className="text-indigo-400 hover:text-white transition-colors text-xs font-bold mr-4">Metrics</button>
                                        <button className="text-indigo-400 hover:text-white transition-colors text-xs font-bold">Manage</button>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>

            </main>
        </div>
    );
};

export default Dashboard;
