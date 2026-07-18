<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
// Note: Laravel standard is to drop the 'Model' suffix, but you can keep them if preferred.
use App\Models\CreateInvoice;
use App\Models\CreateInvoiceBreakup;
use App\Models\CustomerMaster;
use App\Models\Product;

class CreateInvoicesController extends Controller
{
    /**
     * Display a listing of the invoices.
     */
    public function index()
    {
        // Eloquent automatically orders and fetches data
        $invoices = CreateInvoice::orderBy('id', 'desc')->get();
        
        // Laravel uses dot notation for view directories
        return view('create_invoice.index', compact('invoices'));
    }

    /**
     * Display the initial invoice creation page (customer selection).
     */
    public function invoice()
    {
        $customers = CustomerMaster::orderBy('id', 'desc')->get();
        
        return view('create_invoice.invoice', compact('customers'));
    }

    /**
     * Show the form for creating a new invoice.
     */
    public function create($id)
    {
        // findOrFail automatically throws a 404 (PageNotFound) if the ID doesn't exist
        $customer = CustomerMaster::findOrFail($id);
        $products = Product::all();

        return view('create_invoice.create', compact('customer', 'products'));
    }

    /**
     * Store a newly created invoice and its breakups in storage.
     */
    public function store(Request $request)
    {
        // 1. Validation
        // In Laravel, validation exceptions automatically redirect back with errors and input.
        $validated = $request->validate([
            'fk_customer_id'   => 'required|integer',
            'company_name'     => 'required|string|max:255',
            'invoice_no'       => 'required|string|max:50|unique:create_invoices,invoice_no',
            'invoice_date'     => 'required|date_format:Y-m-d',
            'invoice_type'     => 'required|in:Sale,Refund,Invoice',
            
            // Array validation
            'product_name.*'   => 'required|string',
            'amount.*'         => 'required|numeric|gt:0',       // gt:0 translates to greater_than[0]
            'discount.*'       => 'required|numeric|gt:0',
            'gst_percent.*'    => 'required|numeric|gt:0',
            'gst_amount.*'     => 'required|numeric|gt:0',
            'final_amount.*'   => 'required|numeric|gt:0',
            'mobile_no'        => 'required|digits:10',          // exact_length[10] + numeric
        ]);

        try {
            // Start Transaction
            DB::beginTransaction();

            // Step 1 & 2: Collect data, save invoice, and get instance (including generated ID)
            // Note: Make sure these fields are in the $fillable array of CreateInvoice model
            $invoice = CreateInvoice::create([
                'company_name'   => $request->input('company_name'),
                'customer_type'  => $request->input('customer_type'),
                'customer_name'  => $request->input('customer_name'),
                'mobile_no'      => $request->input('mobile_no'),
                'gst_no'         => $request->input('gst_no'),
                'pan_tan'        => $request->input('pan_tan'),
                'invoice_no'     => $request->input('invoice_no'),
                'invoice_date'   => $request->input('invoice_date'),
                'invoice_type'   => $request->input('invoice_type'),
                'fk_customer_id' => $request->input('fk_customer_id'),
            ]);

            // Step 3: Collect array data and save product breakup rows
            $product_names = $request->input('product_name', []);
            $amounts       = $request->input('amount', []);
            $discounts     = $request->input('discount', []);
            $gst_percents  = $request->input('gst_percent', []);
            $gst_amounts   = $request->input('gst_amount', []);
            $final_amounts = $request->input('final_amount', []);
            $remarks       = $request->input('remarks', []);

            $breakups = [];
            foreach ($product_names as $index => $product) {
                $breakups[] = [
                    'invoice_id'   => $invoice->id,
                    'product_name' => $product,
                    'fin_year'     => $product_names[$index], 
                    'amount'       => $amounts[$index] ?? 0,
                    'discount'     => $discounts[$index] ?? 0,
                    'gst_percent'  => $gst_percents[$index] ?? 0,
                    'gst_amount'   => $gst_amounts[$index] ?? 0,
                    'final_amount' => $final_amounts[$index] ?? 0,
                    'remarks'      => $remarks[$index] ?? null,
                    'customer_id'  => $invoice->fk_customer_id,
                    'company_name' => $invoice->company_name,
                    'invoice_no'   => $invoice->invoice_no,
                    // If using mass insert, manually add timestamps if required by your schema
                    'created_at'   => now(),
                    'updated_at'   => now(),
                ];
            }

            // Bulk insert is highly efficient in Laravel
            CreateInvoiceBreakup::insert($breakups);

            // Commit Transaction
            DB::commit();

            // Redirect back to your 'invoice' route with success flash message
            return redirect()->route('invoice')->with('success', 'Invoice created successfully.');

        } catch (\Exception $e) {
            // Rollback on any failure
            DB::rollBack();
            
            return redirect()->back()
                ->withInput()
                ->with('error', 'Something went wrong while saving invoice breakup: ' . $e->getMessage());
        }
    }
}