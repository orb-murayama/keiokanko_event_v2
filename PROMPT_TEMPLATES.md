# プロンプトテンプレート集

このドキュメントは、今後の開発でUI統一やスタイル変更を依頼する際に使用できるプロンプトテンプレートをまとめたものです。

---

## 📋 テンプレート1: UI統一の修正依頼

```
[機能A]の[UI要素]を[機能B]と同じスタイルに統一してください。

変更内容：
1. [具体的な変更1]（例：ボタンを右寄せにする）
2. [具体的な変更2]（例：リセットボタンを追加する）
3. [具体的な変更3]（例：フォームレイアウトを変更する）

参考にする機能：[機能B]の[ファイル名]
変更対象ファイル：[機能A]の[ファイル名]

確認事項：
- 既存の機能が正常に動作することを確認してください
- CSSクラス名は[機能B]と統一してください
- JavaScriptの動作も同様に統一してください
```

### 使用例：

```
会員一覧のボタンをアカウント一覧と同じスタイルに統一してください。

変更内容：
1. 新規登録ボタンを右寄せにする
2. 検索ボタンを右寄せにする
3. リセットボタンを追加する
4. ボタンの形をアカウント一覧と同じにする

参考にする機能：アカウント一覧の public/accounts-list.html
変更対象ファイル：会員一覧の public/members-list.html

確認事項：
- 既存の検索機能が正常に動作することを確認してください
- CSSクラス名はアカウント一覧と統一してください
- JavaScriptの動作も同様に統一してください
```

---

## 📋 テンプレート2: フォームスタイルの統一

```
[機能A]のフォームスタイルを[機能B]と統一してください。

統一する要素：
- フォームレイアウト（admin-form, form-row, form-group）
- ボタン配置（form-actions）
- ボタンスタイル（btn btn-primary, btn btn-secondary）
- アイコン使用（FontAwesome）

変更対象：
- HTML: [ファイルパス]
- JavaScript: [ファイルパス]（必要に応じて）

追加機能：
- リセットボタン（検索条件をクリアして再読み込み）
```

### 使用例：

```
イベント一覧のフォームスタイルをアカウント一覧と統一してください。

統一する要素：
- フォームレイアウト（admin-form, form-row, form-group）
- ボタン配置（form-actions）
- ボタンスタイル（btn btn-primary, btn btn-secondary）
- アイコン使用（FontAwesome）

変更対象：
- HTML: public/events-list.html
- JavaScript: public/js/pages/admin-events.js

追加機能：
- リセットボタン（検索条件をクリアして再読み込み）
```

---

## 📋 テンプレート3: 必須マークの統一

```
[機能A]の必須マークを[機能B]と同じ形式に統一してください。

Before:
<label for="field" class="form-label required">フィールド名</label>

After:
<label for="field" class="form-label">
  <span class="text-danger">*</span> フィールド名
</label>

変更対象フィールド：
1. [フィールド名1]
2. [フィールド名2]
3. ...

変更対象ファイル：[ファイルパス]
```

### 使用例：

```
イベント編集画面の必須マークをアカウント編集と同じ形式に統一してください。

Before:
<label for="title" class="form-label required">イベント名</label>

After:
<label for="title" class="form-label">
  <span class="text-danger">*</span> イベント名
</label>

変更対象フィールド：
1. イベント名
2. 開催日
3. 定員
4. 料金

変更対象ファイル：public/events-edit.html
```

---

## 📋 テンプレート4: ボタンアクションの統一

```
[機能A]のボタンアクションを[機能B]と同じCSSクラスに統一してください。

Before:
<button class="btn btn-sm btn-primary">編集</button>
<button class="btn btn-sm btn-danger">削除</button>

After:
<a href="#" class="action-link action-link-primary">
  <i class="fas fa-edit"></i> 編集
</a>
<a href="#" class="action-link action-link-danger">
  <i class="fas fa-trash"></i> 削除
</a>

変更対象：
- HTML: [ファイルパス]（必要に応じて）
- JavaScript: [ファイルパス]
```

### 使用例：

```
イベント一覧のボタンアクションをアカウント一覧と同じCSSクラスに統一してください。

Before:
<button class="btn btn-sm btn-primary">編集</button>
<button class="btn btn-sm btn-danger">削除</button>

After:
<a href="#" class="action-link action-link-primary">
  <i class="fas fa-edit"></i> 編集
</a>
<a href="#" class="action-link action-link-danger">
  <i class="fas fa-trash"></i> 削除
</a>

変更対象：
- JavaScript: public/js/pages/admin-events.js
```

---

## 📋 テンプレート5: 大規模な削除・編集作業（安全確認付き）

```
[機能名]を静的HTMLファイル化してください。

⚠️ 作業前の必須確認事項：
1. 削除範囲を明示的に提示して、私の承認を得てから実行してください
2. 削除範囲の前後10行を表示してください
3. 削除範囲に含まれる重要コード（ルート定義、API、関数など）をリスト化してください
4. バックアップを作成してください（git commit推奨）

実施ステップ：
Step1: 影響分析
  - 現在のルート定義を確認
  - 依存する他のルートを確認
  - 参考にする静的HTML実装を確認

Step2: 削除範囲の特定
  - src/index.tsx の削除開始行と終了行を提示
  - 削除範囲の前後10行を表示
  - 他機能のルートに影響がないか確認
  - ⚠️ この時点で私の承認を得る

Step3: 新規ファイル作成
  - public/[機能名]-list.html
  - public/[機能名]-edit.html
  - public/js/pages/admin-[機能名].js
  - public/js/pages/admin-[機能名]-edit.js

Step4: ルート追加と既存ルート削除
  - GET /admin/[機能名] → /[機能名]-list.html
  - GET /admin/[機能名]/new → /[機能名]-edit.html?id=new
  - GET /admin/[機能名]/:id/edit → /[機能名]-edit.html?id=:id
  - ⚠️ 削除実行前に再度確認を求める

Step5: 動作確認
  - ビルドとサーバー再起動
  - 各URLの動作テスト
  - API連携の確認

各ステップで私の承認を得てから次のステップに進んでください。
```

### 使用例：

```
イベント管理を静的HTMLファイル化してください。

⚠️ 作業前の必須確認事項：
1. 削除範囲を明示的に提示して、私の承認を得てから実行してください
2. 削除範囲の前後10行を表示してください
3. 削除範囲に含まれる重要コード（ルート定義、API、関数など）をリスト化してください
4. バックアップを作成してください（git commit推奨）

実施ステップ：
Step1: 影響分析
  - 現在のイベント管理のルート定義を確認
  - 依存する他のルート（予約、支払いなど）を確認
  - アカウント管理や会員管理の静的HTML実装を参考にする

Step2: 削除範囲の特定
  - src/index.tsx のイベント管理セクションの削除開始行と終了行を提示
  - 削除範囲の前後10行を表示
  - 他機能（予約管理など）のルートに影響がないか確認
  - ⚠️ この時点で私の承認を得る

Step3: 新規ファイル作成
  - public/events-list.html
  - public/events-edit.html
  - public/js/pages/admin-events.js
  - public/js/pages/admin-events-edit.js

Step4: ルート追加と既存ルート削除
  - GET /admin/events → /events-list.html
  - GET /admin/events/new → /events-edit.html?id=new
  - GET /admin/events/:id/edit → /events-edit.html?id=:id
  - ⚠️ 削除実行前に再度確認を求める

Step5: 動作確認
  - ビルドとサーバー再起動
  - 各URLの動作テスト（一覧、新規、編集）
  - API連携の確認（GET /api/events, POST /api/events, PUT /api/events/:id）

各ステップで私の承認を得てから次のステップに進んでください。
```

---

## 🎯 プロンプト作成のポイント

### 1. 具体的な変更内容を明記
- Before/Afterの例を示す
- 参考にするファイルを明示する
- 変更する要素を列挙する

### 2. 変更対象ファイルを明確に
- HTMLファイル
- JavaScriptファイル
- CSSファイル（必要に応じて）

### 3. 確認事項を列挙
- 既存機能の動作確認
- スタイルの統一性
- JavaScriptの動作確認

### 4. 段階的な実施を要求
- Step1: 調査・影響分析
- Step2: 変更計画の提示
- Step3: 実装
- Step4: 動作確認

### 5. 承認フローを含める
- 各ステップで承認を求める
- 削除範囲の確認を必須とする
- 削除前に前後10行を表示して確認する

### 6. バックアップを必須化
- 大規模な変更前に必ずgit commitを作成する
- ロールバック可能な状態を維持する

---

## 📝 実際の適用事例

### 事例1: 会員管理の静的HTMLファイル化

**プロンプト：**
```
会員管理を静的HTMLファイル化してください。

⚠️ 作業前の必須確認事項：
1. 削除範囲を明示的に提示して、私の承認を得てから実行してください
2. 削除範囲の前後10行を表示してください
3. バックアップを作成してください

実施ステップ：
Step1: src/index.tsx の会員管理セクションの範囲を特定
Step2: 削除範囲の前後10行を表示して、私の承認を得る
Step3: 新規ファイル作成
Step4: ルート追加と既存ルート削除
Step5: 動作確認

各ステップで私の承認を得てから次のステップに進んでください。
```

**結果：**
- ✅ src/index.tsx の行数：19,228行 → 18,296行（-932行、-4.8%）
- ✅ バンドルサイズ：769KB → 752KB（-17KB、-2.2%）
- ✅ 静的ファイル作成：members-list.html、members-edit.html、admin-members.js、admin-member-edit.js
- ✅ ルート変更：インラインHTML → リダイレクト

### 事例2: 会員一覧のボタンレイアウト統一

**プロンプト：**
```
会員一覧のボタンをアカウント一覧と同じスタイルに統一してください。

変更内容：
1. 新規登録ボタンを右寄せにする
2. 検索ボタンを右寄せにする
3. リセットボタンを追加する
4. ボタンの形をアカウント一覧と同じにする

参考にする機能：アカウント一覧の public/accounts-list.html
変更対象ファイル：
- public/members-list.html
- public/js/pages/admin-members.js
```

**結果：**
- ✅ フォームスタイルを `admin-form` + `form-actions` に変更
- ✅ 検索ボタンとリセットボタンを右寄せで配置
- ✅ リセット機能を実装（検索条件クリア + 再読み込み）

### 事例3: 会員編集の必須マーク統一

**プロンプト：**
```
会員編集画面の必須マークをアカウント編集と同じ形式に統一してください。

Before:
<label for="email" class="form-label required">メールアドレス</label>

After:
<label for="email" class="form-label">
  <span class="text-danger">*</span> メールアドレス
</label>

変更対象フィールド：
1. メールアドレス
2. 姓
3. 名
4. 姓（カナ）
5. 名（カナ）
6. 性別
7. 生年月日
8. 郵便番号
9. 都道府県
10. 住所
11. 携帯電話

変更対象ファイル：public/members-edit.html
```

**結果：**
- ✅ 11個のフィールドの必須マークを統一
- ✅ CSSクラスを `required` → `text-danger` に変更
- ✅ アカウント編集と会員編集のUIが統一

---

## 🚨 重要な注意事項

### ミスを防ぐためのチェックリスト

#### ✅ 大規模な削除・編集作業前

1. **バックアップ作成**
   - `git add -A && git commit -m "backup: [作業内容]の前にバックアップ"`

2. **削除範囲の確認**
   - 削除開始行と終了行を明示
   - 削除範囲の前後10行を表示
   - 削除範囲に含まれる重要コードをリスト化

3. **影響範囲の分析**
   - 依存する他のルートを確認
   - 削除対象外のコードが含まれていないか確認
   - 他機能への影響がないか確認

4. **承認フローの実施**
   - 削除範囲を提示して承認を得る
   - 実行前に再度確認を求める
   - 各ステップで承認を得る

#### ✅ ファイル編集時

1. **参考ファイルの確認**
   - 統一先のファイルを事前に確認
   - CSSクラス名を正確に把握
   - JavaScriptの動作を理解

2. **段階的な実施**
   - 1つのファイルずつ変更
   - 変更後に動作確認
   - 問題があればロールバック

3. **動作確認**
   - ビルドとサーバー再起動
   - ブラウザでの動作確認
   - API連携の確認

---

## 📚 関連ドキュメント

- `README.md`: プロジェクト全体のドキュメント
- `public/accounts-list.html`: アカウント一覧の参考実装
- `public/accounts-edit.html`: アカウント編集の参考実装
- `public/members-list.html`: 会員一覧の実装
- `public/members-edit.html`: 会員編集の実装

---

**最終更新日**: 2026-01-26
