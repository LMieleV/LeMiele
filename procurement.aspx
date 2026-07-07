<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Working with Procurement, made simple. A practical guide for everyone at Etex on when to involve Procurement, how Source-to-Pay flows, and where to start your request.">
<title>Etex Procurement — Working with Procurement, made simple</title>
<style>
/* ============================================================
   ETEX PROCUREMENT — Working with Procurement, made simple
   Single-file, zero-dependency · Etex brand · SharePoint-safe
   Palette sourced from the Procurement deck:
   charcoal #151D21 · orange #F06D0C · slate #5A6770
   mist #DDE1E4 · deep blue #00324B · green #80A45D
   ============================================================ */

:root{
  --bg:        #10161a;
  --bg-2:      #151d21;
  --bg-3:      #1b252b;
  --ink:       #edf1f4;
  --ink-dim:   #c0c9cf;
  --muted:     #7f8b94;
  --accent:    #f06d0c;
  --accent-soft:#ffb36b;
  --accent-tint:#ffe1c3;
  --green:     #80a45d;
  --blue:      #0064a0;
  --line:      rgba(221,225,228,.14);
  --line-soft: rgba(221,225,228,.08);
  --serif:     Georgia, "Times New Roman", "Palatino Linotype", serif;
  --sans:      "Segoe UI", -apple-system, BlinkMacSystemFont, "Helvetica Neue", Helvetica, Arial, sans-serif;
  --ease-out:  cubic-bezier(.19,1,.22,1);
  --ease-soft: cubic-bezier(.25,.46,.45,.94);
}

*,*::before,*::after{ margin:0; padding:0; box-sizing:border-box; }

html{ scroll-behavior:smooth; }
@media (prefers-reduced-motion: reduce){ html{ scroll-behavior:auto; } }

body{
  background:var(--bg);
  color:var(--ink);
  font-family:var(--sans);
  font-size:16px;
  line-height:1.6;
  -webkit-font-smoothing:antialiased;
  overflow-x:hidden;
}

::selection{ background:var(--accent); color:#10161a; }

a{ color:inherit; text-decoration:none; }
ul{ list-style:none; }
img,svg,canvas{ display:block; max-width:100%; }

/* ---------- skip link ---------- */
.skip-link{
  position:fixed; top:-60px; left:16px; z-index:300;
  background:var(--accent); color:#10161a;
  padding:.6em 1.2em; font-size:.8rem; font-weight:600;
  transition:top .2s;
}
.skip-link:focus{ top:16px; }

/* ---------- film-grain overlay ---------- */
.grain{
  position:fixed; inset:-50%; z-index:120; pointer-events:none;
  width:200%; height:200%;
  background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='240' height='240'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='2' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='240' height='240' filter='url(%23n)' opacity='0.5'/%3E%3C/svg%3E");
  opacity:.04;
  animation:grain 8s steps(10) infinite;
}
@keyframes grain{
  0%,100%{ transform:translate(0,0); }
  10%{ transform:translate(-4%,-6%); } 20%{ transform:translate(-8%,3%); }
  30%{ transform:translate(5%,-8%); }  40%{ transform:translate(-3%,10%); }
  50%{ transform:translate(-9%,-4%); } 60%{ transform:translate(8%,2%); }
  70%{ transform:translate(2%,8%); }   80%{ transform:translate(-6%,4%); }
  90%{ transform:translate(7%,-5%); }
}

/* ---------- scroll progress ---------- */
.progress{
  position:fixed; top:0; left:0; height:2px; width:100%;
  z-index:210; transform-origin:0 50%; transform:scaleX(0);
  background:linear-gradient(90deg,var(--accent),var(--accent-soft));
}

/* ---------- custom cursor ---------- */
.cursor-dot,.cursor-ring{
  position:fixed; top:0; left:0; z-index:250; pointer-events:none;
  border-radius:50%; transform:translate(-50%,-50%);
  opacity:0; transition:opacity .3s;
}
.cursor-dot{ width:6px; height:6px; background:var(--accent); }
.cursor-ring{
  width:36px; height:36px; border:1px solid rgba(240,109,12,.55);
  transition:width .35s var(--ease-out), height .35s var(--ease-out),
             border-color .35s, opacity .3s, background .35s;
}
body.cursor-on .cursor-dot, body.cursor-on .cursor-ring{ opacity:1; }
body.cursor-hover .cursor-ring{
  width:72px; height:72px;
  border-color:rgba(240,109,12,.9);
  background:rgba(240,109,12,.08);
}
@media (hover:none), (pointer:coarse){
  .cursor-dot,.cursor-ring{ display:none; }
}

/* ---------- preloader ---------- */
.preloader{
  position:fixed; inset:0; z-index:200;
  background:var(--bg);
  display:flex; align-items:center; justify-content:center;
  transition:transform 1s var(--ease-out);
}
.preloader__inner{ text-align:center; }
.preloader__count{
  font-family:var(--serif); font-size:clamp(4rem,12vw,9rem);
  font-weight:400; letter-spacing:-.03em; line-height:1;
  color:var(--ink); font-variant-numeric:tabular-nums;
}
.preloader__label{
  margin-top:1rem; font-size:.7rem; letter-spacing:.4em;
  text-transform:uppercase; color:var(--muted);
}
.preloader__label b{ color:var(--accent); font-weight:600; }
body.loaded .preloader{ transform:translateY(-100%); pointer-events:none; }

/* ---------- etex chevron mark ---------- */
.xmark{ display:inline-block; vertical-align:middle; }

/* ---------- nav ---------- */
.nav{
  position:fixed; top:0; left:0; right:0; z-index:150;
  display:flex; align-items:center; justify-content:space-between;
  padding:1.5rem clamp(1.2rem,4vw,3.5rem);
  border-bottom:1px solid transparent;
}
.nav.scrolled{
  background:rgba(16,22,26,.78);
  -webkit-backdrop-filter:blur(14px); backdrop-filter:blur(14px);
  padding-top:.9rem; padding-bottom:.9rem;
  border-bottom-color:var(--line-soft);
}
.nav__logo{ display:flex; align-items:center; gap:.7rem; }
.nav__wordmark{
  font-family:var(--sans); font-weight:700; font-size:1.25rem;
  letter-spacing:-.02em; line-height:1; display:flex; align-items:center; gap:.28rem;
}
.nav__division{
  font-size:.68rem; letter-spacing:.3em; text-transform:uppercase;
  color:var(--muted); border-left:1px solid var(--line);
  padding-left:.7rem; margin-left:.1rem;
}
.nav__links{ display:flex; gap:2rem; }
.nav__links a{
  font-size:.7rem; letter-spacing:.2em; text-transform:uppercase;
  color:var(--ink-dim); position:relative; padding:.3em 0;
  transition:color .3s;
}
.nav__links a::after{
  content:""; position:absolute; left:0; bottom:0; height:1px; width:100%;
  background:var(--accent); transform:scaleX(0); transform-origin:100% 50%;
  transition:transform .45s var(--ease-out);
}
.nav__links a:hover{ color:var(--ink); }
.nav__links a:hover::after{ transform:scaleX(1); transform-origin:0 50%; }
.nav__cta{
  font-size:.7rem; letter-spacing:.2em; text-transform:uppercase;
  border:1px solid var(--accent); color:var(--accent-tint);
  padding:.75em 1.5em; border-radius:99px;
  transition:background .35s, color .35s;
}
.nav__cta:hover{ background:var(--accent); color:#10161a; }
@media (max-width:960px){ .nav__links{ display:none; } }
@media (max-width:520px){ .nav__division{ display:none; } }

.nav{ opacity:0; transform:translateY(-12px); transition:opacity .8s .2s, transform .8s .2s var(--ease-out), background .5s, padding .5s, border-color .5s; }
body.loaded .nav{ opacity:1; transform:none; }

/* ---------- hero ---------- */
.hero{
  position:relative; min-height:100svh;
  display:flex; flex-direction:column; justify-content:center;
  padding:7rem clamp(1.2rem,4vw,3.5rem) 3rem;
  overflow:hidden;
}
.hero__canvas{ position:absolute; inset:0; width:100%; height:100%; }
.hero::after{
  content:""; position:absolute; inset:0; pointer-events:none;
  background:radial-gradient(ellipse at 50% 120%, transparent 40%, rgba(16,22,26,.65) 100%);
}
.hero__inner{ position:relative; z-index:2; max-width:1400px; margin:0 auto; width:100%; }

.hero__eyebrow{
  display:flex; align-items:center; gap:1rem;
  font-size:.72rem; letter-spacing:.35em; text-transform:uppercase;
  color:var(--accent); margin-bottom:clamp(1.5rem,3vh,2.6rem);
}
.hero__eyebrow::before{ content:""; width:3rem; height:1px; background:var(--accent); }

.hero__title{
  font-family:var(--serif); font-weight:400;
  font-size:clamp(2.7rem,7.6vw,7.2rem);
  line-height:1.02; letter-spacing:-.025em;
}
.hero__title .italic{ font-style:italic; color:var(--accent-soft); }
.line-mask{ display:block; overflow:hidden; padding-bottom:.06em; margin-bottom:-.06em; }
.line-mask > span{
  display:block; transform:translateY(115%);
  transition:transform 1.2s var(--ease-out);
}
body.loaded .line-mask:nth-child(1) > span{ transition-delay:.55s; }
body.loaded .line-mask:nth-child(2) > span{ transition-delay:.68s; }
body.loaded .line-mask > span{ transform:translateY(0); }

.hero__foot{
  display:flex; justify-content:space-between; align-items:flex-end;
  gap:2rem; margin-top:clamp(2rem,5vh,3.5rem);
  opacity:0; transform:translateY(20px);
  transition:opacity 1s 1.05s, transform 1s 1.05s var(--ease-out);
}
body.loaded .hero__foot{ opacity:1; transform:none; }
.hero__desc{ max-width:460px; color:var(--ink-dim); font-size:.98rem; }
.hero__scroll{
  display:flex; align-items:center; gap:.8rem;
  font-size:.68rem; letter-spacing:.3em; text-transform:uppercase; color:var(--muted);
  white-space:nowrap;
}
.hero__scroll .tick{
  width:1px; height:3.2rem; background:var(--line); position:relative; overflow:hidden;
}
.hero__scroll .tick::after{
  content:""; position:absolute; top:-100%; left:0; width:100%; height:100%;
  background:var(--accent); animation:scrolltick 2.2s var(--ease-soft) infinite;
}
@keyframes scrolltick{ 0%{ top:-100%; } 55%{ top:0; } 100%{ top:100%; } }

.hero__meta{
  display:grid; grid-template-columns:repeat(4,1fr); gap:1px;
  background:var(--line-soft); border:1px solid var(--line-soft);
  margin-top:clamp(2.2rem,5vh,3.5rem);
  opacity:0; transform:translateY(20px);
  transition:opacity 1s 1.25s, transform 1s 1.25s var(--ease-out);
}
body.loaded .hero__meta{ opacity:1; transform:none; }
.hero__meta div{
  background:rgba(21,29,33,.72); padding:1.1rem 1.3rem;
  -webkit-backdrop-filter:blur(6px); backdrop-filter:blur(6px);
}
.hero__meta dt{
  font-size:.62rem; letter-spacing:.28em; text-transform:uppercase;
  color:var(--accent); margin-bottom:.35rem;
}
.hero__meta dd{ font-size:.92rem; color:var(--ink-dim); }
@media (max-width:820px){
  .hero__meta{ grid-template-columns:repeat(2,1fr); }
  .hero__foot{ flex-direction:column; align-items:flex-start; }
}

/* ---------- marquee ---------- */
.marquee{
  border-top:1px solid var(--line-soft); border-bottom:1px solid var(--line-soft);
  padding:1.3rem 0; overflow:hidden; white-space:nowrap;
  background:var(--bg-2);
}
.marquee__track{ display:inline-flex; animation:marquee 30s linear infinite; }
.marquee:hover .marquee__track{ animation-play-state:paused; }
.marquee__item{
  font-family:var(--serif); font-size:clamp(1.05rem,2.2vw,1.55rem);
  letter-spacing:.03em; color:var(--ink-dim);
  padding:0 1.5rem; display:inline-flex; align-items:center; gap:3rem;
}
.marquee__item::after{ content:"‹›"; color:var(--accent); font-size:.8em; letter-spacing:-.1em; }
@keyframes marquee{ to{ transform:translateX(-50%); } }

/* ---------- shared section chrome ---------- */
.section{ padding:clamp(4.5rem,11vh,9rem) clamp(1.2rem,4vw,3.5rem); position:relative; }
.section--alt{ background:var(--bg-2); }
.section__inner{ max-width:1400px; margin:0 auto; }
.section__head{
  display:flex; align-items:baseline; justify-content:space-between;
  gap:2rem; margin-bottom:clamp(2rem,5vh,3.5rem);
  border-bottom:1px solid var(--line-soft); padding-bottom:1.3rem;
}
.section__label{ font-size:.72rem; letter-spacing:.35em; text-transform:uppercase; color:var(--accent); }
.section__num{ font-family:var(--serif); font-style:italic; color:var(--muted); font-size:.95rem; white-space:nowrap; }
.section__title{
  font-family:var(--serif); font-weight:400;
  font-size:clamp(2rem,4.6vw,3.8rem); line-height:1.08; letter-spacing:-.02em;
  max-width:900px; margin-bottom:1.4rem;
}
.section__title em{ color:var(--accent-soft); }
.section__intro{ color:var(--ink-dim); max-width:640px; font-size:1rem; margin-bottom:clamp(2rem,5vh,3.5rem); }

/* reveal-on-scroll */
.reveal{ opacity:0; transform:translateY(42px); transition:opacity 1s var(--ease-soft), transform 1s var(--ease-out); }
.reveal.in-view{ opacity:1; transform:none; }
.reveal[data-delay="1"]{ transition-delay:.12s; }
.reveal[data-delay="2"]{ transition-delay:.24s; }
.reveal[data-delay="3"]{ transition-delay:.36s; }

/* ---------- manifesto ---------- */
.manifesto p{
  font-family:var(--serif); font-weight:400;
  font-size:clamp(1.6rem,4vw,3.2rem);
  line-height:1.3; letter-spacing:-.01em; max-width:1150px;
}
.manifesto .w{ color:rgba(237,241,244,.15); transition:color .5s var(--ease-soft); }
.manifesto .w.on{ color:var(--ink); }
.manifesto .w.em{ font-style:italic; }
.manifesto .w.em.on{ color:var(--accent-soft); }
.manifesto__src{
  margin-top:2rem; font-size:.68rem; letter-spacing:.3em;
  text-transform:uppercase; color:var(--muted);
}

/* ---------- two-panel comparison (when / principles / raci) ---------- */
.duo{ display:grid; grid-template-columns:1fr 1fr; gap:1px; background:var(--line-soft); border:1px solid var(--line-soft); }
.duo__panel{ background:var(--bg); padding:clamp(1.6rem,3.5vw,3rem); }
.section--alt .duo__panel{ background:var(--bg-2); }
.duo__panel--hot{ box-shadow:inset 3px 0 0 var(--accent); }
.duo__panel--cool{ box-shadow:inset 3px 0 0 var(--muted); }
.duo__kicker{
  font-size:.65rem; letter-spacing:.3em; text-transform:uppercase;
  color:var(--muted); margin-bottom:.5rem;
}
.duo__panel--hot .duo__kicker{ color:var(--accent); }
.duo__panel h3{
  font-family:var(--serif); font-weight:400; font-size:clamp(1.3rem,2.2vw,1.8rem);
  letter-spacing:-.01em; margin-bottom:1.4rem;
}
.list li{
  position:relative; padding:.65rem 0 .65rem 1.8rem;
  color:var(--ink-dim); font-size:.95rem;
  border-bottom:1px solid var(--line-soft);
}
.list li:last-child{ border-bottom:0; }
.list li::before{
  content:"›"; position:absolute; left:.2rem; top:.55rem;
  color:var(--accent); font-family:var(--serif); font-size:1.1em;
}
.list--cool li::before{ content:"—"; color:var(--muted); font-size:.9em; }
.duo__hint{
  margin-top:1.6rem; padding:1rem 1.2rem;
  background:rgba(240,109,12,.07); border-left:2px solid var(--accent);
  font-size:.88rem; color:var(--ink-dim);
}
.duo__hint b{ color:var(--accent-tint); font-weight:600; }
.duo__panel--cool .duo__hint{ background:rgba(221,225,228,.05); border-left-color:var(--muted); }
.duo__panel--cool .duo__hint b{ color:var(--ink); }
@media (max-width:860px){ .duo{ grid-template-columns:1fr; } }

/* ---------- pull quote band ---------- */
.pull{
  margin-top:clamp(2.5rem,6vh,4rem); text-align:center;
  padding:clamp(2rem,5vh,3.2rem) 1rem;
  border-top:1px solid var(--line-soft); border-bottom:1px solid var(--line-soft);
}
.pull p{
  font-family:var(--serif); font-size:clamp(1.4rem,3.2vw,2.4rem);
  line-height:1.3; letter-spacing:-.01em; max-width:900px; margin:0 auto;
}
.pull em{ color:var(--accent-soft); }
.pull__mark{ color:var(--accent); font-family:var(--serif); }

/* ---------- source-to-pay steps ---------- */
.steps{ display:grid; grid-template-columns:repeat(5,1fr); gap:clamp(.9rem,1.6vw,1.6rem); counter-reset:step; }
.step{
  border-top:1px solid var(--line); padding-top:1.3rem; position:relative;
}
.step::before{
  content:""; position:absolute; top:-1px; left:0; height:1px; width:0;
  background:var(--accent); transition:width 1.1s var(--ease-out);
}
.step.in-view::before{ width:100%; }
.step__num{
  font-family:var(--serif); font-style:italic; color:var(--accent);
  font-size:.9rem; display:block; margin-bottom:1rem;
}
.step h3{
  font-family:var(--serif); font-weight:400; font-size:clamp(1.15rem,1.7vw,1.5rem);
  letter-spacing:-.01em; margin-bottom:.6rem;
}
.step p{ color:var(--muted); font-size:.85rem; line-height:1.6; }
@media (max-width:1000px){ .steps{ grid-template-columns:repeat(2,1fr); row-gap:2.6rem; } }
@media (max-width:520px){ .steps{ grid-template-columns:1fr; } }

.s2p-notes{
  display:grid; grid-template-columns:repeat(3,1fr); gap:1px;
  background:var(--line-soft); border:1px solid var(--line-soft);
  margin-top:clamp(2.5rem,6vh,4rem);
}
.s2p-notes div{ background:var(--bg); padding:1.6rem 1.8rem; }
.s2p-notes dt{
  font-size:.65rem; letter-spacing:.28em; text-transform:uppercase;
  color:var(--accent); margin-bottom:.7rem;
}
.s2p-notes dd{ color:var(--ink-dim); font-size:.9rem; }
@media (max-width:860px){ .s2p-notes{ grid-template-columns:1fr; } }

/* ---------- paths ---------- */
.paths{ display:grid; grid-template-columns:1fr 1fr; gap:clamp(1.2rem,2.5vw,2rem); }
.path{
  border:1px solid var(--line-soft); background:var(--bg-2);
  padding:clamp(1.6rem,3vw,2.6rem); position:relative; overflow:hidden;
  transition:border-color .4s, transform .5s var(--ease-out);
}
.path:hover{ border-color:rgba(240,109,12,.45); transform:translateY(-4px); }
.path__tag{
  display:inline-block; font-size:.65rem; letter-spacing:.3em; text-transform:uppercase;
  color:var(--accent); border:1px solid rgba(240,109,12,.4);
  padding:.4em 1em; border-radius:99px; margin-bottom:1.3rem;
}
.path h3{
  font-family:var(--serif); font-weight:400;
  font-size:clamp(1.5rem,2.6vw,2.2rem); letter-spacing:-.015em; margin-bottom:.4rem;
}
.path__sub{ color:var(--muted); font-size:.9rem; margin-bottom:1.6rem; }
.path h4{
  font-size:.65rem; letter-spacing:.28em; text-transform:uppercase;
  color:var(--ink-dim); margin:1.6rem 0 .6rem;
}
.timeline{ margin-top:.4rem; }
.timeline li{
  display:grid; grid-template-columns:6.2rem 1fr; gap:1rem;
  padding:.55rem 0; border-bottom:1px solid var(--line-soft);
  font-size:.9rem; color:var(--ink-dim);
}
.timeline li:last-child{ border-bottom:0; }
.timeline .t{
  font-family:var(--serif); font-style:italic; color:var(--accent-soft);
  white-space:nowrap; font-size:.92rem;
}
@media (max-width:860px){ .paths{ grid-template-columns:1fr; } }

/* ---------- shared responsibility banner ---------- */
.together{
  margin-top:clamp(2rem,5vh,3rem); text-align:center;
  padding:1.4rem; border:1px solid rgba(240,109,12,.35);
  background:rgba(240,109,12,.06);
  font-family:var(--serif); font-size:clamp(1.15rem,2.4vw,1.7rem);
}
.together em{ color:var(--accent-soft); }
.together + p{ text-align:center; color:var(--muted); font-size:.85rem; margin-top:1rem; }

/* ---------- sustainability ---------- */
.sustain .section__label{ color:var(--green); }
.sustain .list li::before{ color:var(--green); }
.sustain .pull{ border-color:rgba(128,164,93,.25); }
.sustain .pull em{ color:#a8c785; }
.sustain__link{
  display:inline-flex; align-items:center; gap:.6rem;
  margin-top:1.4rem; font-size:.75rem; letter-spacing:.22em; text-transform:uppercase;
  color:#a8c785; border-bottom:1px solid rgba(128,164,93,.5); padding-bottom:.3em;
  transition:letter-spacing .4s var(--ease-out), color .3s;
}
.sustain__link:hover{ letter-spacing:.3em; color:var(--ink); }
.pull__src{
  margin-top:1.6rem; font-size:.65rem; letter-spacing:.3em;
  text-transform:uppercase; color:var(--muted);
}

/* ---------- tools grid ---------- */
.tools{ display:grid; grid-template-columns:repeat(3,1fr); gap:1px; background:var(--line-soft); border:1px solid var(--line-soft); }
.tool{
  background:var(--bg); padding:clamp(1.5rem,2.5vw,2.2rem);
  transition:background .4s; position:relative;
}
.tool:hover{ background:var(--bg-3); }
.tool__mono{
  font-family:var(--serif); font-style:italic; font-size:1rem;
  color:var(--accent); border:1px solid rgba(240,109,12,.4);
  width:2.9em; height:2.9em; border-radius:50%;
  display:flex; align-items:center; justify-content:center;
  margin-bottom:1.2rem; transition:background .35s, color .35s;
}
.tool:hover .tool__mono{ background:var(--accent); color:#10161a; }
.tool h3{
  font-family:var(--serif); font-weight:400; font-size:1.35rem;
  letter-spacing:-.01em; margin-bottom:.5rem;
}
.tool p{ color:var(--muted); font-size:.88rem; min-height:3.2em; }
.tool__status{
  display:inline-block; margin-top:1.1rem;
  font-size:.6rem; letter-spacing:.24em; text-transform:uppercase;
  color:var(--ink-dim); border:1px solid var(--line);
  padding:.45em 1em; border-radius:99px;
}
@media (max-width:1000px){ .tools{ grid-template-columns:repeat(2,1fr); } }
@media (max-width:560px){ .tools{ grid-template-columns:1fr; } }

/* ---------- contacts ---------- */
.contacts{ display:grid; grid-template-columns:repeat(4,1fr); gap:clamp(1rem,1.8vw,1.6rem); }
.contact{
  border:1px solid var(--line-soft); padding:1.8rem 1.6rem;
  background:var(--bg-2); position:relative;
  transition:border-color .4s, transform .5s var(--ease-out);
}
.contact:hover{ border-color:rgba(240,109,12,.45); transform:translateY(-4px); }
.contact__mono{
  font-family:var(--serif); font-style:italic; color:var(--accent);
  font-size:.95rem; margin-bottom:2.2rem; display:block;
}
.contact h3{
  font-family:var(--serif); font-weight:400; font-size:1.2rem;
  letter-spacing:-.01em; margin-bottom:.45rem;
}
.contact p{ color:var(--muted); font-size:.85rem; }
.contact__arrow{
  position:absolute; top:1.5rem; right:1.5rem;
  font-family:var(--serif); color:var(--muted);
  transition:transform .4s var(--ease-out), color .3s;
}
.contact:hover .contact__arrow{ transform:translate(3px,-3px) rotate(45deg); color:var(--accent); }
@media (max-width:1000px){ .contacts{ grid-template-columns:repeat(2,1fr); } }
@media (max-width:520px){ .contacts{ grid-template-columns:1fr; } }

/* ---------- faq ---------- */
.faq details{
  border-bottom:1px solid var(--line-soft);
}
.faq details:first-of-type{ border-top:1px solid var(--line-soft); }
.faq summary{
  cursor:pointer; list-style:none;
  display:grid; grid-template-columns:auto 1fr auto; align-items:baseline;
  gap:clamp(1rem,3vw,2.4rem);
  padding:clamp(1.2rem,2.6vh,1.7rem) 0;
  transition:color .3s;
}
.faq summary::-webkit-details-marker{ display:none; }
.faq summary:hover{ color:var(--accent-tint); }
.faq .q-num{ font-family:var(--serif); font-style:italic; color:var(--accent); font-size:.9rem; }
.faq .q-text{
  font-family:var(--serif); font-weight:400;
  font-size:clamp(1.15rem,2.4vw,1.7rem); letter-spacing:-.01em;
}
.faq .q-plus{
  font-family:var(--serif); font-size:1.4rem; color:var(--muted);
  transition:transform .4s var(--ease-out), color .3s;
}
.faq details[open] .q-plus{ transform:rotate(45deg); color:var(--accent); }
.faq .a{
  padding:0 0 1.7rem calc(.9rem + clamp(1rem,3vw,2.4rem));
  color:var(--ink-dim); font-size:.95rem; max-width:820px;
}
.faq .a b{ color:var(--accent-tint); font-weight:600; }

/* ---------- footer ---------- */
.footer{
  border-top:1px solid var(--line-soft);
  padding:clamp(4.5rem,11vh,8rem) clamp(1.2rem,4vw,3.5rem) 2.5rem;
  position:relative; overflow:hidden;
}
.footer__inner{ max-width:1400px; margin:0 auto; position:relative; z-index:2; }
.footer__quote{
  font-family:var(--serif); font-size:clamp(1.2rem,2.4vw,1.7rem);
  color:var(--ink-dim); max-width:760px; line-height:1.5; margin-bottom:clamp(2.5rem,6vh,4rem);
}
.footer__quote em{ color:var(--accent-soft); }
.footer__cta{
  display:block; font-family:var(--serif); font-weight:400;
  font-size:clamp(2.5rem,8.4vw,7.5rem); letter-spacing:-.03em; line-height:1.04;
}
.footer__cta em{ font-style:italic; color:var(--accent-soft); }
.footer__actions{ display:flex; gap:1rem; flex-wrap:wrap; margin-top:2.6rem; }
.btn{
  display:inline-flex; align-items:center; gap:.7rem;
  font-size:.72rem; letter-spacing:.22em; text-transform:uppercase;
  padding:1em 2em; border-radius:99px; border:1px solid var(--accent);
  transition:background .35s, color .35s, transform .4s var(--ease-out);
}
.btn:hover{ transform:translateY(-2px); }
.btn--primary{ background:var(--accent); color:#10161a; font-weight:600; }
.btn--primary:hover{ background:var(--accent-soft); border-color:var(--accent-soft); }
.btn--ghost{ color:var(--accent-tint); }
.btn--ghost:hover{ background:rgba(240,109,12,.12); }
.footer__grid{
  display:flex; justify-content:space-between; align-items:flex-end; gap:2rem;
  margin-top:clamp(3rem,8vh,5.5rem); padding-top:2rem;
  border-top:1px solid var(--line-soft);
  font-size:.7rem; letter-spacing:.18em; text-transform:uppercase; color:var(--muted);
  flex-wrap:wrap;
}
.footer__grid a{ transition:color .3s; }
.footer__grid a:hover{ color:var(--accent); }
.footer__brand{ display:flex; align-items:center; gap:.6rem; }
.footer__brand .word{ font-weight:700; font-size:1rem; letter-spacing:-.02em; text-transform:none; color:var(--ink); }

/* ---------- reduced motion ---------- */
@media (prefers-reduced-motion: reduce){
  *,*::before,*::after{ animation-duration:.01ms !important; animation-iteration-count:1 !important; transition-duration:.01ms !important; }
  .line-mask > span{ transform:none; }
  .reveal{ opacity:1; transform:none; }
  .manifesto .w{ color:var(--ink); }
  .marquee__track{ animation:none; }
  .grain{ animation:none; }
}
</style>
</head>
<body>

<a class="skip-link" href="#main">Skip to content</a>

<div class="grain" aria-hidden="true"></div>
<div class="progress" aria-hidden="true"></div>
<div class="cursor-dot" aria-hidden="true"></div>
<div class="cursor-ring" aria-hidden="true"></div>

<!-- preloader -->
<div class="preloader" aria-hidden="true">
  <div class="preloader__inner">
    <div class="preloader__count" id="loadCount">0</div>
    <div class="preloader__label"><b>etex</b> · procurement</div>
  </div>
</div>

<!-- nav -->
<header class="nav" id="nav">
  <a class="nav__logo" href="#top" aria-label="Etex Procurement — home">
    <span class="nav__wordmark">ete<svg class="xmark" width="17" height="16" viewBox="0 0 20 18" aria-hidden="true"><path d="M2 2 L10 9 L18 2" stroke="#edf1f4" stroke-width="3.4" fill="none"/><path d="M2 16.5 L10 10 L18 16.5" stroke="#f06d0c" stroke-width="3.4" fill="none"/></svg></span>
    <span class="nav__division">Procurement</span>
  </a>
  <nav class="nav__links" aria-label="Primary">
    <a href="#when" data-hover>When</a>
    <a href="#principles" data-hover>Principles</a>
    <a href="#s2p" data-hover>Source-to-Pay</a>
    <a href="#start" data-hover>Start a request</a>
    <a href="#tools" data-hover>Tools</a>
    <a href="#faq" data-hover>FAQ</a>
  </nav>
  <a class="nav__cta" href="#contact" data-hover>Contact us</a>
</header>

<main id="main">

<!-- 01 · hero -->
<section class="hero" id="top">
  <canvas class="hero__canvas" id="heroCanvas" aria-hidden="true"></canvas>
  <div class="hero__inner">
    <p class="hero__eyebrow">How to work with Procurement</p>
    <h1 class="hero__title" aria-label="Working with Procurement, made simple.">
      <span class="line-mask" aria-hidden="true"><span>Working with Procurement,</span></span>
      <span class="line-mask" aria-hidden="true"><span class="italic">made simple.</span></span>
    </h1>
    <div class="hero__foot">
      <p class="hero__desc">
        A practical guide for everyone at Etex on when to involve Procurement,
        how Source-to-Pay flows, and where to start your request.
      </p>
      <div class="hero__scroll">
        <span>Scroll</span>
        <span class="tick" aria-hidden="true"></span>
      </div>
    </div>
    <dl class="hero__meta">
      <div><dt>Audience</dt><dd>All Etex colleagues</dd></div>
      <div><dt>Owner</dt><dd>Group Procurement</dd></div>
      <div><dt>Updated</dt><dd>27 May 2026</dd></div>
      <div><dt>Reading time</dt><dd>~6 minutes</dd></div>
    </dl>
  </div>
</section>

<!-- marquee -->
<div class="marquee" aria-hidden="true">
  <div class="marquee__track" id="marqueeTrack">
    <span class="marquee__item">Building better together</span>
    <span class="marquee__item">Involve Procurement early</span>
    <span class="marquee__item">One front door</span>
    <span class="marquee__item">Source-to-Pay</span>
    <span class="marquee__item">Partnership-driven</span>
    <span class="marquee__item">Sustainability embedded</span>
  </div>
</div>

<!-- engagement principle · manifesto -->
<section class="section manifesto">
  <div class="section__inner">
    <p id="manifestoText">Involve Procurement <em>early.</em> Early engagement saves time, reduces risk, and increases <em>value.</em></p>
    <p class="manifesto__src">‹ Procurement engagement principle ›</p>
  </div>
</section>

<!-- 02 · when to contact -->
<section class="section section--alt" id="when">
  <div class="section__inner">
    <div class="section__head">
      <span class="section__label">When should I contact Procurement?</span>
      <span class="section__num">02 / 08</span>
    </div>
    <h2 class="section__title reveal">Bring us in <em>before</em> a commitment is made.</h2>
    <p class="section__intro reveal">
      If it involves an external supplier, a new contract, or a commercial conversation,
      Procurement should be at the table. The earlier we're looped in, the more value
      we can unlock — together.
    </p>
    <div class="duo">
      <div class="duo__panel duo__panel--hot reveal">
        <p class="duo__kicker">› Contact Procurement when you</p>
        <h3>You need our support</h3>
        <ul class="list">
          <li>need to buy goods or services (direct or indirect)</li>
          <li>plan a new supplier, contract or tender</li>
          <li>request a purchase order (PO)</li>
          <li>negotiate commercial terms</li>
          <li>start a CAPEX, service or project involving external suppliers</li>
          <li>need guidance on sourcing, compliance or sustainability</li>
        </ul>
        <p class="duo__hint"><b>In doubt?</b> Involve Procurement early — early engagement saves time, reduces risk, and increases value.</p>
      </div>
      <div class="duo__panel duo__panel--cool reveal" data-delay="1">
        <p class="duo__kicker">— You typically do not need us when</p>
        <h3>You can proceed on your own</h3>
        <ul class="list list--cool">
          <li>purchasing via approved catalogues or tools already in place</li>
          <li>following an existing contract or framework agreement without changes</li>
          <li>renewing under previously negotiated commercial conditions</li>
          <li>handling expenses already covered by an established supplier panel</li>
        </ul>
        <p class="duo__hint"><b>Still unsure?</b> Ask your local or regional Procurement lead — a 15-minute conversation is always cheaper than the wrong contract.</p>
      </div>
    </div>
  </div>
</section>

<!-- 03 · engagement principles -->
<section class="section" id="principles">
  <div class="section__inner">
    <div class="section__head">
      <span class="section__label">How we work best together</span>
      <span class="section__num">03 / 08</span>
    </div>
    <h2 class="section__title reveal">Our engagement <em>principles.</em></h2>
    <p class="section__intro reveal">
      Procurement is a shared discipline. The business owns the need; we own the process.
      Here's what we expect from each other so we can move faster, smarter and with less friction.
    </p>
    <div class="duo">
      <div class="duo__panel duo__panel--cool reveal">
        <p class="duo__kicker">What we expect from</p>
        <h3>The business</h3>
        <ul class="list list--cool">
          <li>involve Procurement early, before commitments are made</li>
          <li>clearly define the business need, scope and timing</li>
          <li>ensure budget availability and business ownership</li>
          <li>collaborate openly and transparently</li>
        </ul>
      </div>
      <div class="duo__panel duo__panel--hot reveal" data-delay="1">
        <p class="duo__kicker">What Procurement</p>
        <h3>Commits to provide</h3>
        <ul class="list">
          <li>professional sourcing and negotiation support</li>
          <li>compliant and fair procurement processes</li>
          <li>sustainability and risk considerations built in</li>
          <li>pragmatic and digital ways of working</li>
        </ul>
      </div>
    </div>
    <div class="pull reveal">
      <p><span class="pull__mark">‹</span> Our common objective is to <em>enable the business</em> while protecting Etex's interests. <span class="pull__mark">›</span></p>
    </div>
  </div>
</section>

<!-- 04 · source-to-pay -->
<section class="section section--alt" id="s2p">
  <div class="section__inner">
    <div class="section__head">
      <span class="section__label">The Source-to-Pay process at a glance</span>
      <span class="section__num">04 / 08</span>
    </div>
    <h2 class="section__title reveal">One <em>end-to-end</em> framework, across Etex.</h2>
    <div class="steps" style="margin-top:clamp(2rem,5vh,3.5rem)">
      <div class="step">
        <span class="step__num">— 01</span>
        <h3>Define the business need</h3>
        <p>Describe scope, budget owner, and timing.</p>
      </div>
      <div class="step">
        <span class="step__num">— 02</span>
        <h3>Source the solution</h3>
        <p>RFQ, RFP or negotiation with shortlisted suppliers.</p>
      </div>
      <div class="step">
        <span class="step__num">— 03</span>
        <h3>Select &amp; contract</h3>
        <p>Award decision, T&amp;Cs and contract signature.</p>
      </div>
      <div class="step">
        <span class="step__num">— 04</span>
        <h3>Create PR &amp; PO</h3>
        <p>Purchase request and order in SAP / Ariba.</p>
      </div>
      <div class="step">
        <span class="step__num">— 05</span>
        <h3>Receive &amp; pay</h3>
        <p>Goods receipt, invoice match and payment.</p>
      </div>
    </div>
    <dl class="s2p-notes reveal">
      <div>
        <dt>What you do</dt>
        <dd>Bring a clear brief: scope, estimated spend, expected timeframe and key stakeholders involved.</dd>
      </div>
      <div>
        <dt>What Procurement does</dt>
        <dd>We translate the need into a sourcing strategy, validate market options and define the engagement model with you.</dd>
      </div>
      <div>
        <dt>Tools &amp; references</dt>
        <dd>SAP · Ariba · ARIS process maps · Contract repository · SHAPE4U</dd>
      </div>
    </dl>
  </div>
</section>

<!-- 05 · start a request -->
<section class="section" id="start">
  <div class="section__inner">
    <div class="section__head">
      <span class="section__label">How do I start a request?</span>
      <span class="section__num">05 / 08</span>
    </div>
    <h2 class="section__title reveal">Two paths, one <em>front door.</em></h2>
    <p class="section__intro reveal">
      Choose the path that matches your situation. If you're not sure, start a sourcing
      request — we'll route it to the right team within one working day.
    </p>
    <div class="paths">
      <article class="path reveal" data-hover>
        <span class="path__tag">› Path A</span>
        <h3>New sourcing or supplier</h3>
        <p class="path__sub">No existing contract or new commercial scope</p>
        <h4>What we'll need from you</h4>
        <ul class="list">
          <li>Description and scope of the need</li>
          <li>Estimated spend and budget owner</li>
          <li>Expected timeframe and key milestones</li>
          <li>Key stakeholders (Legal, Finance, IT)</li>
          <li>Sustainability, risk or compliance considerations</li>
        </ul>
        <h4>› Typical timeline</h4>
        <ul class="timeline">
          <li><span class="t">Week 0</span><span>Intake call &amp; brief alignment</span></li>
          <li><span class="t">Week 1–3</span><span>Market analysis &amp; RFQ/RFP launch</span></li>
          <li><span class="t">Week 4–6</span><span>Negotiation &amp; supplier selection</span></li>
          <li><span class="t">Week 7+</span><span>Contract signature &amp; onboarding</span></li>
        </ul>
      </article>
      <article class="path reveal" data-delay="1" data-hover>
        <span class="path__tag">› Path B</span>
        <h3>Purchase request / order</h3>
        <p class="path__sub">Operational purchasing under existing scope</p>
        <h4>Operational purchasing checklist</h4>
        <ul class="list">
          <li>Create a PR in the relevant system</li>
          <li>Ensure approvals follow the standard workflow</li>
          <li>Reference the active contract or framework agreement</li>
          <li>Confirm budget code and cost-centre alignment</li>
          <li>Procurement supports PO creation and compliance</li>
        </ul>
        <h4>› Typical PR-to-PO flow</h4>
        <ul class="timeline">
          <li><span class="t">Day 0</span><span>Submit PR in SAP / Ariba</span></li>
          <li><span class="t">Day 1–2</span><span>Approval workflow routing</span></li>
          <li><span class="t">Day 3</span><span>PO issued to supplier</span></li>
          <li><span class="t">Day 7+</span><span>Goods receipt &amp; invoice match</span></li>
        </ul>
      </article>
    </div>
  </div>
</section>

<!-- 06 · shared responsibility -->
<section class="section section--alt" id="raci">
  <div class="section__inner">
    <div class="section__head">
      <span class="section__label">Roles &amp; responsibilities</span>
      <span class="section__num">06 / 08</span>
    </div>
    <h2 class="section__title reveal">A <em>shared</em> responsibility.</h2>
    <p class="section__intro reveal">
      Working with Procurement is a partnership. Here's how we split — and where we meet.
    </p>
    <div class="duo">
      <div class="duo__panel duo__panel--cool reveal">
        <p class="duo__kicker">Business</p>
        <h3>You own the need</h3>
        <ul class="list list--cool">
          <li>Define business needs and specifications</li>
          <li>Confirm budget and business priority</li>
          <li>Participate in supplier evaluations</li>
        </ul>
      </div>
      <div class="duo__panel duo__panel--hot reveal" data-delay="1">
        <p class="duo__kicker">Procurement</p>
        <h3>We own the process</h3>
        <ul class="list">
          <li>Define sourcing strategy and approach</li>
          <li>Run sourcing, negotiation and selection</li>
          <li>Ensure compliance, governance and best value</li>
        </ul>
      </div>
    </div>
    <p class="together reveal">‹ Own supplier performance — <em>together</em> ›</p>
    <p>Procurement also manages contracts, supplier risk &amp; procurement governance on behalf of the group.</p>
  </div>
</section>

<!-- 07 · sustainability -->
<section class="section sustain" id="sustainability">
  <div class="section__inner">
    <div class="section__head">
      <span class="section__label">Sustainability &amp; compliance</span>
      <span class="section__num">07 / 08</span>
    </div>
    <h2 class="section__title reveal">Embedded, <em>not bolted on.</em></h2>
    <p class="section__intro reveal">
      At Etex, sustainability and compliance are integral to procurement decisions —
      not an afterthought. Procurement:
    </p>
    <div class="reveal" style="max-width:640px">
      <ul class="list">
        <li>integrates ESG principles into sourcing decisions</li>
        <li>performs supplier risk and compliance checks</li>
        <li>supports responsible and ethical sourcing across categories</li>
      </ul>
      <a class="sustain__link" href="https://etexgroup.sharepoint.com/sites/corp.be.global-purchasing-support/OneP2P" data-hover>Learn more: Sustainable Procurement ›</a>
    </div>
    <div class="pull reveal">
      <p><span class="pull__mark">‹</span> Sustainability is not an add-on — it is <em>embedded in how we source</em> and select our partners. <span class="pull__mark">›</span></p>
      <p class="pull__src">— Procurement leadership · 2026 commitment</p>
    </div>
  </div>
</section>

<!-- 08 · tools -->
<section class="section section--alt" id="tools">
  <div class="section__inner">
    <div class="section__head">
      <span class="section__label">Tools you may interact with</span>
      <span class="section__num">08 / 08</span>
    </div>
    <h2 class="section__title reveal">The <em>digital toolbox.</em></h2>
    <p class="section__intro reveal">
      Depending on your role and need, you may work with one or more of these systems.
    </p>
    <div class="tools">
      <div class="tool reveal">
        <span class="tool__mono" aria-hidden="true">SA</span>
        <h3>SAP / Ariba</h3>
        <p>Purchase requests, purchase orders and sourcing events.</p>
        <span class="tool__status">Operational · SSO enabled</span>
      </div>
      <div class="tool reveal" data-delay="1">
        <span class="tool__mono" aria-hidden="true">CR</span>
        <h3>Contract repository</h3>
        <p>Search, retrieve and manage active supplier agreements.</p>
        <span class="tool__status">Live · Access on request</span>
      </div>
      <div class="tool reveal" data-delay="2">
        <span class="tool__mono" aria-hidden="true">S4</span>
        <h3>SHAPE4U</h3>
        <p>Etex's savings framework — track, validate and report.</p>
        <span class="tool__status">Procurement &amp; Finance</span>
      </div>
      <div class="tool reveal">
        <span class="tool__mono" aria-hidden="true">ZI</span>
        <h3>Zero Initiatives App</h3>
        <p>Price increase tracker with automated flow.</p>
        <span class="tool__status">Pilot phase</span>
      </div>
      <div class="tool reveal" data-delay="1">
        <span class="tool__mono" aria-hidden="true">PB</span>
        <h3>Power BI reports</h3>
        <p>Spend, savings and category dashboards updated weekly.</p>
        <span class="tool__status">Read-only · Group &amp; BU</span>
      </div>
      <div class="tool reveal" data-delay="2">
        <span class="tool__mono" aria-hidden="true">MT</span>
        <h3>Procurement Teams</h3>
        <p>Community channel for questions, news and announcements.</p>
        <span class="tool__status">Open to all employees</span>
      </div>
    </div>
  </div>
</section>

<!-- 09 · contacts -->
<section class="section" id="contact">
  <div class="section__inner">
    <div class="section__head">
      <span class="section__label">Who to contact</span>
      <span class="section__num">09</span>
    </div>
    <h2 class="section__title reveal">Not sure where to start? We're here to <em>partner.</em></h2>
    <p class="section__intro reveal">
      Reach out to your local team, a category lead, the PMO or our Teams community —
      we'll route you within one working day.
    </p>
    <div class="contacts">
      <article class="contact reveal" data-hover>
        <span class="contact__mono">LP</span>
        <h3>Local / regional Procurement</h3>
        <p>Site- and country-specific contacts</p>
        <span class="contact__arrow" aria-hidden="true">›</span>
      </article>
      <article class="contact reveal" data-delay="1" data-hover>
        <span class="contact__mono">CM</span>
        <h3>Category &amp; commodity managers</h3>
        <p>For specialised sourcing topics</p>
        <span class="contact__arrow" aria-hidden="true">›</span>
      </article>
      <article class="contact reveal" data-delay="2" data-hover>
        <span class="contact__mono">PM</span>
        <h3>Procurement PMO / Process</h3>
        <p>Tools, governance &amp; transformation</p>
        <span class="contact__arrow" aria-hidden="true">›</span>
      </article>
      <article class="contact reveal" data-delay="3" data-hover>
        <span class="contact__mono">TC</span>
        <h3>Procurement Teams channel</h3>
        <p>Community Q&amp;A &amp; updates</p>
        <span class="contact__arrow" aria-hidden="true">›</span>
      </article>
    </div>
  </div>
</section>

<!-- 10 · faq -->
<section class="section section--alt faq" id="faq">
  <div class="section__inner">
    <div class="section__head">
      <span class="section__label">Frequently asked questions</span>
      <span class="section__num">10</span>
    </div>
    <h2 class="section__title reveal">Quick answers to <em>common questions.</em></h2>
    <div class="reveal" style="margin-top:clamp(2rem,5vh,3rem)">
      <details>
        <summary data-hover>
          <span class="q-num">01</span>
          <span class="q-text">How long does a sourcing exercise take?</span>
          <span class="q-plus" aria-hidden="true">+</span>
        </summary>
        <p class="a">Simple RFQs can close in 3–4 weeks; strategic RFPs may run 8–12 weeks. <b>Early engagement</b> with Procurement is the single biggest factor in hitting your target date.</p>
      </details>
      <details>
        <summary data-hover>
          <span class="q-num">02</span>
          <span class="q-text">Can I contact suppliers directly?</span>
          <span class="q-plus" aria-hidden="true">+</span>
        </summary>
        <p class="a">Technical conversations with existing suppliers are fine. For commercial discussions and any new supplier relationship, Procurement should be involved to protect Etex and capture the best terms.</p>
      </details>
      <details>
        <summary data-hover>
          <span class="q-num">03</span>
          <span class="q-text">What about urgent or emergency requests?</span>
          <span class="q-plus" aria-hidden="true">+</span>
        </summary>
        <p class="a">Contact Procurement immediately. We have lightweight pathways for genuine emergencies that still preserve compliance and audit trail.</p>
      </details>
      <details>
        <summary data-hover>
          <span class="q-num">04</span>
          <span class="q-text">Do I need to use Ariba for every purchase?</span>
          <span class="q-plus" aria-hidden="true">+</span>
        </summary>
        <p class="a">Ariba is the default for indirect purchasing across most countries. A handful of categories and sites operate under specific local tools — your local contact can confirm.</p>
      </details>
      <details>
        <summary data-hover>
          <span class="q-num">05</span>
          <span class="q-text">How are sustainability criteria applied?</span>
          <span class="q-plus" aria-hidden="true">+</span>
        </summary>
        <p class="a">For relevant categories, we include ESG criteria in supplier evaluation, request emissions and compliance data, and weight sustainability alongside cost and quality.</p>
      </details>
    </div>
  </div>
</section>

</main>

<!-- footer -->
<footer class="footer">
  <div class="footer__inner">
    <p class="footer__quote reveal">
      ‹ Working with Procurement is designed to be <em>simple, fast and partnership-driven.</em>
      We look forward to building better, together. ›
    </p>
    <a class="footer__cta reveal" href="https://etexgroup.sharepoint.com/sites/corp.be.global-purchasing-support/OneP2P" data-hover>
      Building <em>better,</em> together.
    </a>
    <div class="footer__actions reveal" data-delay="1">
      <a class="btn btn--primary" href="https://etexgroup.sharepoint.com/sites/corp.be.global-purchasing-support/OneP2P" data-hover>Start a sourcing request ›</a>
      <a class="btn btn--ghost" href="https://etexgroup.sharepoint.com/sites/corp.be.global-purchasing-support/OneP2P/SitePages/Home.aspx" data-hover>Visit the SharePoint site</a>
    </div>
    <div class="footer__grid">
      <span class="footer__brand">
        <span class="word">ete<svg class="xmark" width="14" height="13" viewBox="0 0 20 18" aria-hidden="true"><path d="M2 2 L10 9 L18 2" stroke="#edf1f4" stroke-width="3.4" fill="none"/><path d="M2 16.5 L10 10 L18 16.5" stroke="#f06d0c" stroke-width="3.4" fill="none"/></svg></span>
        <span>Group Procurement</span>
      </span>
      <span>Last updated 27 May 2026 · Leander Miele · Procurement</span>
      <a class="top" href="#top" data-hover>Back to top ↑</a>
    </div>
  </div>
</footer>

<script>
(function(){
  "use strict";
  var reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  /* ---------- preloader ---------- */
  var countEl = document.getElementById("loadCount");
  function finishLoad(){ document.body.classList.add("loaded"); }
  if (reduceMotion){
    countEl.textContent = "100";
    finishLoad();
  } else {
    var t0 = null, DUR = 1400;
    function tick(ts){
      if (!t0) t0 = ts;
      var p = Math.min((ts - t0) / DUR, 1);
      var eased = 1 - Math.pow(1 - p, 3);
      countEl.textContent = Math.round(eased * 100);
      if (p < 1) requestAnimationFrame(tick);
      else setTimeout(finishLoad, 250);
    }
    requestAnimationFrame(tick);
  }

  /* ---------- nav + scroll progress ---------- */
  var nav = document.getElementById("nav");
  var progress = document.querySelector(".progress");
  var ticking = false;
  function onScroll(){
    if (ticking) return;
    ticking = true;
    requestAnimationFrame(function(){
      var y = window.scrollY || window.pageYOffset;
      nav.classList.toggle("scrolled", y > 40);
      var max = document.documentElement.scrollHeight - window.innerHeight;
      progress.style.transform = "scaleX(" + (max > 0 ? y / max : 0) + ")";
      updateManifesto();
      ticking = false;
    });
  }
  window.addEventListener("scroll", onScroll, { passive:true });

  /* ---------- custom cursor ---------- */
  var fine = window.matchMedia("(hover:hover) and (pointer:fine)").matches;
  if (fine && !reduceMotion){
    var dot = document.querySelector(".cursor-dot");
    var ring = document.querySelector(".cursor-ring");
    var mx = -100, my = -100, rx = -100, ry = -100, cursorOn = false;
    document.addEventListener("mousemove", function(e){
      mx = e.clientX; my = e.clientY;
      if (!cursorOn){ cursorOn = true; document.body.classList.add("cursor-on"); }
    });
    document.addEventListener("mouseleave", function(){
      cursorOn = false; document.body.classList.remove("cursor-on");
    });
    (function loop(){
      rx += (mx - rx) * 0.16; ry += (my - ry) * 0.16;
      dot.style.transform  = "translate(" + (mx - 3) + "px," + (my - 3) + "px)";
      ring.style.transform = "translate(" + rx + "px," + ry + "px) translate(-50%,-50%)";
      requestAnimationFrame(loop);
    })();
    document.querySelectorAll("[data-hover]").forEach(function(el){
      el.addEventListener("mouseenter", function(){ document.body.classList.add("cursor-hover"); });
      el.addEventListener("mouseleave", function(){ document.body.classList.remove("cursor-hover"); });
    });
  }

  /* ---------- marquee: duplicate track for seamless loop ---------- */
  var track = document.getElementById("marqueeTrack");
  track.innerHTML += track.innerHTML;

  /* ---------- reveal on scroll ---------- */
  var io = new IntersectionObserver(function(entries){
    entries.forEach(function(en){
      if (en.isIntersecting){
        en.target.classList.add("in-view");
        io.unobserve(en.target);
      }
    });
  }, { threshold:0.15, rootMargin:"0px 0px -6% 0px" });
  document.querySelectorAll(".reveal, .step").forEach(function(el){ io.observe(el); });

  /* ---------- manifesto word-by-word reveal ---------- */
  var mani = document.getElementById("manifestoText");
  var words = [];
  (function splitWords(){
    var nodes = Array.prototype.slice.call(mani.childNodes);
    mani.textContent = "";
    nodes.forEach(function(node){
      var em = node.nodeType === 1 && node.tagName === "EM";
      var text = node.textContent;
      text.split(/\s+/).forEach(function(w){
        if (!w) return;
        var span = document.createElement("span");
        span.className = "w" + (em ? " em" : "");
        span.textContent = w;
        mani.appendChild(span);
        mani.appendChild(document.createTextNode(" "));
        words.push(span);
      });
    });
  })();
  function updateManifesto(){
    if (reduceMotion || !words.length) return;
    var rect = mani.getBoundingClientRect();
    var vh = window.innerHeight;
    var start = vh * 0.85, end = vh * 0.45;
    var p = (start - rect.top) / (start - end + rect.height);
    p = Math.max(0, Math.min(1, p));
    var n = Math.round(p * words.length);
    words.forEach(function(w, i){ w.classList.toggle("on", i < n); });
  }

  /* ---------- hero canvas: drifting brand orbs + chevron particles ---------- */
  var canvas = document.getElementById("heroCanvas");
  var ctx = canvas.getContext("2d");
  var W, H, DPR, orbs = [], parts = [];
  var PART_N = 70, LINK_D = 130;

  function resize(){
    DPR = Math.min(window.devicePixelRatio || 1, 2);
    W = canvas.offsetWidth; H = canvas.offsetHeight;
    canvas.width = W * DPR; canvas.height = H * DPR;
    ctx.setTransform(DPR, 0, 0, DPR, 0, 0);
  }
  resize();
  window.addEventListener("resize", function(){ resize(); if (reduceMotion) draw(0); });

  function rnd(a, b){ return a + Math.random() * (b - a); }

  /* orbs in brand hues: etex orange, deep blue, slate */
  var HUES = ["240,109,12", "0,80,130", "90,103,112"];
  var ALPHAS = [0.10, 0.08, 0.07];
  for (var i = 0; i < 3; i++){
    orbs.push({
      x: rnd(0.15, 0.85), y: rnd(0.2, 0.8),
      r: rnd(0.28, 0.5),
      dx: rnd(-0.00006, 0.00006), dy: rnd(-0.00005, 0.00005),
      hue: HUES[i], alpha: ALPHAS[i],
      ph: rnd(0, Math.PI * 2)
    });
  }
  for (var j = 0; j < PART_N; j++){
    parts.push({
      x: Math.random(), y: Math.random(),
      vx: rnd(-0.00008, 0.00008), vy: rnd(-0.00006, 0.00006),
      s: rnd(0.6, 1.8)
    });
  }

  function draw(t){
    ctx.clearRect(0, 0, W, H);

    orbs.forEach(function(o){
      var ox = (o.x + Math.sin(t * 0.0001 + o.ph) * 0.04) * W;
      var oy = (o.y + Math.cos(t * 0.00013 + o.ph) * 0.05) * H;
      var r = o.r * Math.min(W, H) * (1 + Math.sin(t * 0.0002 + o.ph) * 0.08);
      var g = ctx.createRadialGradient(ox, oy, 0, ox, oy, r);
      g.addColorStop(0, "rgba(" + o.hue + "," + o.alpha + ")");
      g.addColorStop(1, "rgba(" + o.hue + ",0)");
      ctx.fillStyle = g;
      ctx.fillRect(ox - r, oy - r, r * 2, r * 2);
      o.x += o.dx; o.y += o.dy;
      if (o.x < 0.05 || o.x > 0.95) o.dx *= -1;
      if (o.y < 0.05 || o.y > 0.95) o.dy *= -1;
    });

    ctx.lineWidth = 0.5;
    for (var a = 0; a < PART_N; a++){
      var p = parts[a];
      p.x += p.vx; p.y += p.vy;
      if (p.x < 0 || p.x > 1) p.vx *= -1;
      if (p.y < 0 || p.y > 1) p.vy *= -1;
      var px = p.x * W, py = p.y * H;
      ctx.fillStyle = "rgba(237,241,244,0.32)";
      ctx.beginPath();
      ctx.arc(px, py, p.s * 0.7, 0, Math.PI * 2);
      ctx.fill();
      for (var b = a + 1; b < PART_N; b++){
        var q = parts[b];
        var dx = (q.x - p.x) * W, dy = (q.y - p.y) * H;
        var d = Math.sqrt(dx * dx + dy * dy);
        if (d < LINK_D){
          ctx.strokeStyle = "rgba(240,109,12," + (0.13 * (1 - d / LINK_D)) + ")";
          ctx.beginPath();
          ctx.moveTo(px, py);
          ctx.lineTo(q.x * W, q.y * H);
          ctx.stroke();
        }
      }
    }
  }

  if (reduceMotion){
    draw(0);
  } else {
    var heroVisible = true;
    new IntersectionObserver(function(entries){
      heroVisible = entries[0].isIntersecting;
    }).observe(canvas);
    (function animate(t){
      if (heroVisible) draw(t);
      requestAnimationFrame(animate);
    })(0);
  }

  onScroll();
})();
</script>
</body>
</html>
