@echo off
setlocal enabledelayedexpansion

:: Create temp readability.js
set "tmpjs=%TEMP%\readability.js"
(
echo (function() {
echo   function loadReadabilityAndSimplify() {
echo     var iframe = document.createElement('iframe');
echo     iframe.style.position = 'fixed';
echo     iframe.style.top = 0;
echo     iframe.style.left = 0;
echo     iframe.style.width = '100%%';
echo     iframe.style.height = '100%%';
echo     iframe.style.zIndex = 999999;
echo     iframe.style.background = 'white';
echo     document.body.innerHTML = '';
echo     document.body.appendChild(iframe);
echo
echo     fetch('https://unpkg.com/@mozilla/readability@0.4.4/Readability.js')
echo       .then(res => res.text())
echo       .then(lib => {
echo         iframe.contentWindow.eval(lib);
echo         const base = document.cloneNode(true);
echo         const reader = new iframe.contentWindow.Readability(base);
echo         const article = reader.parse();
echo         iframe.contentDocument.body.innerHTML = `
echo           <article style="margin: 4em auto; max-width: 720px; font-family: sans-serif; line-height: 1.6; padding: 2em;">
echo             <h1>${article.title}</h1>
echo             ${article.content}
echo           </article>
echo         `;
echo       });
echo   }
echo   loadReadabilityAndSimplify();
echo })();
) > "!tmpjs!"

:: Use qutebrowser to evaluate it
qutebrowser --target window --temp-basedir --evaljs "!tmpjs!"

