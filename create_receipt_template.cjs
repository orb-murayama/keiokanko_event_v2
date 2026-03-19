const ExcelJS = require('exceljs');

async function createReceiptTemplate() {
  const workbook = new ExcelJS.Workbook();
  const worksheet = workbook.addWorksheet('領収書');
  
  // ページ設定
  worksheet.pageSetup.paperSize = 9; // A4
  worksheet.pageSetup.orientation = 'portrait';
  worksheet.pageSetup.fitToPage = true;
  
  // 列幅設定
  worksheet.columns = [
    { width: 3 },   // A
    { width: 20 },  // B
    { width: 12 },  // C
    { width: 12 },  // D
    { width: 12 },  // E
    { width: 12 },  // F
    { width: 3 }    // G
  ];
  
  // タイトル行
  worksheet.mergeCells('B2:F2');
  const titleCell = worksheet.getCell('B2');
  titleCell.value = '領　収　書';
  titleCell.font = { name: 'メイリオ', size: 20, bold: true };
  titleCell.alignment = { horizontal: 'center', vertical: 'middle' };
  worksheet.getRow(2).height = 35;
  
  // 空行
  worksheet.getRow(3).height = 10;
  
  // 発行日
  worksheet.mergeCells('E4:F4');
  const dateCell = worksheet.getCell('E4');
  dateCell.value = '発行日: {{today}}';
  dateCell.font = { name: 'メイリオ', size: 10 };
  dateCell.alignment = { horizontal: 'right', vertical: 'middle' };
  
  // 予約番号
  worksheet.mergeCells('B5:C5');
  const bookingNumLabelCell = worksheet.getCell('B5');
  bookingNumLabelCell.value = '予約番号:';
  bookingNumLabelCell.font = { name: 'メイリオ', size: 10 };
  bookingNumLabelCell.alignment = { horizontal: 'left', vertical: 'middle' };
  
  worksheet.mergeCells('D5:F5');
  const bookingNumCell = worksheet.getCell('D5');
  bookingNumCell.value = '{{booking_number}}';
  bookingNumCell.font = { name: 'メイリオ', size: 10, bold: true };
  bookingNumCell.alignment = { horizontal: 'left', vertical: 'middle' };
  
  // 宛名
  worksheet.mergeCells('B7:F7');
  const nameCell = worksheet.getCell('B7');
  nameCell.value = '{{booker_name}} 様';
  nameCell.font = { name: 'メイリオ', size: 14, bold: true };
  nameCell.alignment = { horizontal: 'left', vertical: 'middle' };
  worksheet.getRow(7).height = 25;
  
  // 空行
  worksheet.getRow(8).height = 10;
  
  // 金額
  worksheet.mergeCells('B9:C9');
  const amountLabelCell = worksheet.getCell('B9');
  amountLabelCell.value = '下記の通り領収いたしました';
  amountLabelCell.font = { name: 'メイリオ', size: 10 };
  amountLabelCell.alignment = { horizontal: 'left', vertical: 'middle' };
  
  worksheet.mergeCells('B10:F10');
  const totalAmountCell = worksheet.getCell('B10');
  totalAmountCell.value = '金額　¥ {{total_amount}} 円';
  totalAmountCell.font = { name: 'メイリオ', size: 16, bold: true };
  totalAmountCell.alignment = { horizontal: 'center', vertical: 'middle' };
  totalAmountCell.border = {
    top: { style: 'thin' },
    bottom: { style: 'double' },
    left: { style: 'thin' },
    right: { style: 'thin' }
  };
  worksheet.getRow(10).height = 30;
  
  // 空行
  worksheet.getRow(11).height = 15;
  
  // 但し書き
  worksheet.mergeCells('B12:F12');
  const purposeCell = worksheet.getCell('B12');
  purposeCell.value = '但し　{{event_name}}　として';
  purposeCell.font = { name: 'メイリオ', size: 10 };
  purposeCell.alignment = { horizontal: 'left', vertical: 'middle' };
  
  // 空行
  worksheet.getRow(13).height = 15;
  
  // 明細ヘッダー
  worksheet.mergeCells('B14:F14');
  const detailHeaderCell = worksheet.getCell('B14');
  detailHeaderCell.value = '【明細】';
  detailHeaderCell.font = { name: 'メイリオ', size: 11, bold: true };
  detailHeaderCell.alignment = { horizontal: 'left', vertical: 'middle' };
  detailHeaderCell.fill = {
    type: 'pattern',
    pattern: 'solid',
    fgColor: { argb: 'FFE0E0E0' }
  };
  worksheet.getRow(14).height = 20;
  
  // 明細テーブルヘッダー
  const headerRow = worksheet.getRow(15);
  headerRow.height = 22;
  
  const headers = [
    { col: 'B', value: '商品名' },
    { col: 'C', value: '数量' },
    { col: 'D', value: '単価' },
    { col: 'E', value: '小計' },
    { col: 'F', value: '参加日' }
  ];
  
  headers.forEach(h => {
    const cell = worksheet.getCell(`${h.col}15`);
    cell.value = h.value;
    cell.font = { name: 'メイリオ', size: 10, bold: true };
    cell.alignment = { horizontal: 'center', vertical: 'middle' };
    cell.fill = {
      type: 'pattern',
      pattern: 'solid',
      fgColor: { argb: 'FFD0D0D0' }
    };
    cell.border = {
      top: { style: 'thin' },
      bottom: { style: 'thin' },
      left: { style: 'thin' },
      right: { style: 'thin' }
    };
  });
  
  // 明細データ行（繰り返しテンプレート）
  const dataRow = worksheet.getRow(16);
  dataRow.height = 20;
  
  const dataColumns = [
    { col: 'B', value: '{{items.item_name}}', align: 'left' },
    { col: 'C', value: '{{items.quantity}}', align: 'center' },
    { col: 'D', value: '{{items.unit_price}}', align: 'right' },
    { col: 'E', value: '{{items.subtotal}}', align: 'right' },
    { col: 'F', value: '{{items.participation_date}}', align: 'center' }
  ];
  
  dataColumns.forEach(d => {
    const cell = worksheet.getCell(`${d.col}16`);
    cell.value = d.value;
    cell.font = { name: 'メイリオ', size: 10 };
    cell.alignment = { horizontal: d.align, vertical: 'middle' };
    cell.border = {
      top: { style: 'thin' },
      bottom: { style: 'thin' },
      left: { style: 'thin' },
      right: { style: 'thin' }
    };
  });
  
  // 空行
  worksheet.getRow(17).height = 15;
  
  // 発行者情報
  worksheet.mergeCells('B18:F18');
  const issuerHeaderCell = worksheet.getCell('B18');
  issuerHeaderCell.value = '【発行者】';
  issuerHeaderCell.font = { name: 'メイリオ', size: 10, bold: true };
  issuerHeaderCell.alignment = { horizontal: 'left', vertical: 'middle' };
  
  worksheet.mergeCells('B19:F19');
  const issuerNameCell = worksheet.getCell('B19');
  issuerNameCell.value = '京王観光株式会社';
  issuerNameCell.font = { name: 'メイリオ', size: 11, bold: true };
  issuerNameCell.alignment = { horizontal: 'left', vertical: 'middle' };
  
  worksheet.mergeCells('B20:F20');
  const issuerAddressCell = worksheet.getCell('B20');
  issuerAddressCell.value = '〒160-0023 東京都新宿区西新宿1-21-1';
  issuerAddressCell.font = { name: 'メイリオ', size: 9 };
  issuerAddressCell.alignment = { horizontal: 'left', vertical: 'middle' };
  
  worksheet.mergeCells('B21:F21');
  const issuerPhoneCell = worksheet.getCell('B21');
  issuerPhoneCell.value = 'TEL: 03-1234-5678';
  issuerPhoneCell.font = { name: 'メイリオ', size: 9 };
  issuerPhoneCell.alignment = { horizontal: 'left', vertical: 'middle' };
  
  // 空行
  worksheet.getRow(22).height = 10;
  
  // 備考
  worksheet.mergeCells('B23:F23');
  const noteCell = worksheet.getCell('B23');
  noteCell.value = '※この領収書は再発行できませんので、大切に保管してください。';
  noteCell.font = { name: 'メイリオ', size: 8, italic: true };
  noteCell.alignment = { horizontal: 'left', vertical: 'middle' };
  noteCell.fill = {
    type: 'pattern',
    pattern: 'solid',
    fgColor: { argb: 'FFFFFACD' }
  };
  
  // ファイル保存
  await workbook.xlsx.writeFile('./領収書テンプレート.xlsx');
  console.log('✅ 領収書テンプレートを作成しました: 領収書テンプレート.xlsx');
}

createReceiptTemplate().catch(console.error);
