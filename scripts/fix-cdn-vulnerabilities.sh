#!/bin/bash

echo "🔧 Fixing CDN library vulnerabilities..."
echo ""

# Axios 1.6.0 → 1.7.9
echo "📦 Updating Axios to 1.7.9..."
find . -type f \( -name "*.html" -o -name "*.tsx" \) -not -path "./node_modules/*" -not -path "./.git/*" -exec sed -i 's|axios@1.6.0/dist/axios.min.js|axios@1.7.9/dist/axios.min.js|g' {} +

# Vue.js @3 → @3.5.13
echo "📦 Fixing Vue.js version to 3.5.13..."
find . -type f \( -name "*.html" -o -name "*.tsx" \) -not -path "./node_modules/*" -not -path "./.git/*" -exec sed -i 's|vue@3/dist/vue.global.js|vue@3.5.13/dist/vue.global.prod.js|g' {} +
find . -type f \( -name "*.html" -o -name "*.tsx" \) -not -path "./node_modules/*" -not -path "./.git/*" -exec sed -i 's|npm/vue@3"|npm/vue@3.5.13"|g' {} +

# Font Awesome 6.4.0 → 6.7.2
echo "📦 Updating Font Awesome to 6.7.2..."
find . -type f \( -name "*.html" -o -name "*.tsx" \) -not -path "./node_modules/*" -not -path "./.git/*" -exec sed -i 's|fontawesome-free@6.4.0|fontawesome-free@6.7.2|g' {} +

echo ""
echo "✅ CDN libraries updated successfully!"
echo ""
echo "📋 Verification:"
echo ""
echo "Axios version:"
grep -h "axios@" public/*.html src/index.tsx 2>/dev/null | grep -o "axios@[0-9.]*" | sort -u
echo ""
echo "Vue.js version:"
grep -h "vue@" public/*.html src/index.tsx 2>/dev/null | grep -o "vue@[0-9.]*" | sort -u
echo ""
echo "Font Awesome version:"
grep -h "fontawesome-free@" public/*.html src/index.tsx 2>/dev/null | grep -o "fontawesome-free@[0-9.]*" | sort -u
echo ""
echo "🎯 Next steps:"
echo "1. Review changes: git diff"
echo "2. Test build: npm run build"
echo "3. Test locally: npm run dev:sandbox"
echo "4. Commit: git add . && git commit -m 'security: Fix CDN vulnerabilities (Axios, Vue.js, Font Awesome)'"
echo "5. Deploy: npm run deploy"
