// ==UserScript==
// @name         Copy All Page Links Button
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Adds a floating button to copy all links on the current page to the clipboard.
// @author       You
// @match        *://*/*
// @grant        GM_setClipboard
// @run-at       document-idle
// ==/UserScript==

(function() {
    'use strict';

    // Create the button element
    const btn = document.createElement('button');
    btn.innerText = '🔗 Copy Links';
    
    // Style the button so it floats neatly in the corner
    Object.assign(btn.style, {
        position: 'fixed',
        bottom: '20px',
        right: '20px',
        zIndex: '999999',
        padding: '10px 14px',
        backgroundColor: '#333',
        color: '#fff',
        border: 'none',
        borderRadius: '8px',
        cursor: 'pointer',
        fontSize: '14px',
        boxShadow: '0 4px 6px rgba(0,0,0,0.3)',
        fontFamily: 'sans-serif',
        opacity: '0.6',
        transition: 'all 0.2s ease-in-out'
    });

    // Fade the button in when you hover over it
    btn.addEventListener('mouseenter', () => btn.style.opacity = '1');
    btn.addEventListener('mouseleave', () => btn.style.opacity = '0.6');

    // Define what happens when the button is clicked
    btn.addEventListener('click', () => {
        // Grab all 'a' (link) tags and extract their URLs
        const links = Array.from(document.querySelectorAll('a'))
            .map(a => a.href)
            .filter(href => href && href.startsWith('http')); // Ignore empty or javascript-only links
        
        // Remove duplicates using a Set
        const uniqueLinks = [...new Set(links)];

        if (uniqueLinks.length === 0) {
            alert('No web links found on this page!');
            return;
        }

        // Join the links together, each on a new line
        const linksText = uniqueLinks.join('\n');

        // Copy the compiled list to your clipboard
        GM_setClipboard(linksText);

        // Give visual feedback that it worked
        const originalText = btn.innerText;
        btn.innerText = `✅ Copied ${uniqueLinks.length}!`;
        btn.style.backgroundColor = '#28a745'; // Turn green
        
        // Reset the button after 2 seconds
        setTimeout(() => {
            btn.innerText = originalText;
            btn.style.backgroundColor = '#333';
        }, 2000);
    });

    // Inject the button into the webpage
    document.body.appendChild(btn);
})();
