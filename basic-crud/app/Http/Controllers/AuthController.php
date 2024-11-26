<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function register(Request $req)
    {
        $payload = $req->validate([
            'name' => 'required',
            'email' => 'required|email|unique:users',
            'password' => 'required|confirmed',

        ]);
        $createdUser = User::create($payload);
        $token = $createdUser->createToken($req->name);
        return [
            'user' => $createdUser,
            'token' => $token->plainTextToken
        ];
    }

    public function login(Request $req)
    {
        $req->validate([
            'email' => 'required|email|exists:users',
            'password' => 'required|'
        ]);

        $user = User::where('email', $req->email)->first();
        if (!$user || !Hash::check($req->password, $user->password)) {
            return ['error' => 'Make sure you provided valid credentials.'];
        }
        $token = $user->createToken($req->email);
        return [
            'user' => $user,
            'token' => $token->plainTextToken
        ];
    }

    public function logout(Request $req)
    {
        $req->user()->tokens()->delete();
        return ['message' => "logged-out"];
    }
}
