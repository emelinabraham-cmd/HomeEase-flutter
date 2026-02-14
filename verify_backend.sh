#!/bin/bash

# =====================================================
# HomeEase Supabase Deployment Verification Script
# =====================================================

echo "🏠 HomeEase Supabase Backend Verification"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
total_checks=0
passed_checks=0

check_file() {
    total_checks=$((total_checks + 1))
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1"
        passed_checks=$((passed_checks + 1))
    else
        echo -e "${RED}✗${NC} $1 (missing)"
    fi
}

check_dir() {
    total_checks=$((total_checks + 1))
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} $1/"
        passed_checks=$((passed_checks + 1))
    else
        echo -e "${RED}✗${NC} $1/ (missing)"
    fi
}

echo "📁 Checking Directory Structure..."
echo "-----------------------------------"
check_dir "supabase"
check_dir "supabase/migrations"
check_dir "supabase/functions"
check_dir "lib/services"
check_dir "lib/examples"
echo ""

echo "📄 Checking Migration Files..."
echo "-------------------------------"
check_file "supabase/migrations/20240101000000_initial_schema.sql"
check_file "supabase/migrations/20240101000001_rls_policies.sql"
check_file "supabase/migrations/20240101000002_storage_policies.sql"
check_file "supabase/seed.sql"
echo ""

echo "⚡ Checking Edge Functions..."
echo "-----------------------------"
check_file "supabase/functions/create-booking/index.ts"
check_file "supabase/functions/cancel-booking/index.ts"
check_file "supabase/functions/create-support-message/index.ts"
check_file "supabase/functions/admin-create-service/index.ts"
echo ""

echo "📱 Checking Flutter Integration..."
echo "-----------------------------------"
check_file "lib/services/supabase_service.dart"
check_file "lib/examples/flutter_supabase_examples.dart"
echo ""

echo "📚 Checking Documentation..."
echo "-----------------------------"
check_file "SUPABASE_SETUP.md"
check_file "ADMIN_GUIDE.md"
check_file "BACKEND_README.md"
check_file "supabase/README.md"
echo ""

echo "📦 Checking Dependencies..."
echo "---------------------------"
total_checks=$((total_checks + 1))
if grep -q "supabase_flutter" pubspec.yaml; then
    echo -e "${GREEN}✓${NC} supabase_flutter dependency added"
    passed_checks=$((passed_checks + 1))
else
    echo -e "${RED}✗${NC} supabase_flutter dependency missing"
fi
echo ""

echo "=========================================="
echo "Results: $passed_checks/$total_checks checks passed"
echo ""

if [ $passed_checks -eq $total_checks ]; then
    echo -e "${GREEN}✓ All checks passed! Backend is ready for deployment.${NC}"
    echo ""
    echo "Next Steps:"
    echo "1. Create a Supabase project at https://supabase.com"
    echo "2. Run: supabase login"
    echo "3. Run: supabase link --project-ref YOUR_PROJECT_REF"
    echo "4. Run: supabase db push"
    echo "5. Deploy Edge Functions: supabase functions deploy [function-name]"
    echo "6. Update lib/services/supabase_service.dart with your credentials"
    echo ""
    echo "📖 See SUPABASE_SETUP.md for detailed instructions"
    exit 0
else
    echo -e "${RED}✗ Some checks failed. Please review the output above.${NC}"
    exit 1
fi
