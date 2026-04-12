import React from 'react';
import ReactDOM from 'react-dom/client';
import '../design-system/tokens.css';

function App() {
  return (
    <div style={{ padding: '2rem', textAlign: 'center' }}>
      <h1 style={{ color: 'var(--color-accent)', fontFamily: 'DM Sans, sans-serif' }}>
        Spendesk Rebuild Workshop
      </h1>
      <p style={{ color: 'var(--color-text-muted)', marginTop: '1rem' }}>
        Open a terminal and type <code style={{ color: 'var(--color-amount)' }}>claude</code> to start building your module.
      </p>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<App />);
