const CURRENCY_SYMBOLS: Record<string, string> = {
    USD: '$',
    NGN: '₦',
    INR: '₹',
    KES: 'KSh ',
    PHP: '₱',
    GBP: '£',
    EUR: '€',
    GHS: 'GH₵',
    ZAR: 'R',
    BDT: '৳',
};

/** Format a money amount with the currency symbol, e.g. fmt(1234.5) -> "$1,234.50". */
export function fmt(n: number, cur = 'USD'): string {
    const sym = CURRENCY_SYMBOLS[cur] ?? `${cur} `;
    const v = Math.abs(n).toLocaleString('en-US', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
    });

    return `${n < 0 ? '-' : ''}${sym}${v}`;
}

/** Format an integer with thousands separators. */
export function fmtInt(n: number): string {
    return n.toLocaleString('en-US');
}
